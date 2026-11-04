import { lstat, readFile } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';

const checkpoints = [
  'web-build-loaded', 'signed-in', 'client-created', 'client-updated',
  'client-reloaded', 'client-assigned-lawyer-a', 'lawyer-a-client-visible',
  'lawyer-b-client-hidden', 'client-reassigned-lawyer-b', 'lawyer-a-client-hidden',
  'lawyer-b-client-visible',
];

function localDocker() {
  const { DOCKER_HOST, DOCKER_CONTEXT, ...env } = process.env;
  const options = { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] };
  const host = !DOCKER_CONTEXT && DOCKER_HOST ? DOCKER_HOST : execFileSync(
    'docker', ['context', 'inspect', '--format', '{{.Endpoints.docker.Host}}'],
    options,
  ).trim();
  if (!host.startsWith('unix:///') && !host.startsWith('npipe:////./pipe/')) {
    throw new Error('Expected a local Docker socket');
  }
  return (args) => execFileSync('docker', ['--host', host, ...args], { ...options, env });
}

async function verify(docker, suffix, probe, expected, stage) {
  const report = JSON.parse(await readFile(`build/e2e/latest-browser-${suffix}.json`, 'utf8'));
  const match = /^signcob-e2e-(\d+-\d+)$/.exec(report.container);
  if (!match || report.environment !== 'signcob-isolated-e2e' ||
      report.injectedFailure !== probe || report.stage !== stage ||
      report.passed !== !probe || report.journeysPassed !== !probe ||
      report.containerCreationAttempted !== true ||
      report.containerRemovalVerified !== true || report.cleanupPassed !== true ||
      report.privateRuntimeRemoved !== true ||
      JSON.stringify(report.browserCheckpoints) !== JSON.stringify(expected)) {
    throw new Error('Unexpected summary');
  }
  const runtime = await lstat(`build/e2e/run-${match[1]}`).catch((error) => {
    if (error.code !== 'ENOENT') throw error;
  });
  if (runtime) throw new Error('Private runtime remains');
  const containers = docker([
    'container', 'ls', '--all', '--quiet', '--filter', `label=signcob.e2e.run=${match[1]}`,
  ]);
  if (containers.trim()) throw new Error('Disposable container remains');
  return { runId: match[1], started: Date.parse(report.startedAt), finished: Date.parse(report.finishedAt) };
}

try {
  if (process.argv[2] !== '0' || process.argv[3] !== '1') {
    throw new Error('Unexpected runner exit codes');
  }
  const docker = localDocker();
  const normal = await verify(docker, 'result', false,
    [...checkpoints, 'signed-out', 'internal-access-denied'], 'passed');
  const failure = await verify(docker, 'failure-probe', true, checkpoints,
    'injected-failure-after-browser-reassignment');
  if (normal.runId === failure.runId || !(normal.started <= normal.finished &&
      normal.finished <= failure.started && failure.started <= failure.finished)) {
    throw new Error('Expected separate consecutive runs');
  }
  console.log('Browser checkpoints and cleanup verified for success and injected failure.');
} catch {
  console.error('Browser E2E evidence or resource cleanup verification failed.');
  process.exitCode = 1;
}
