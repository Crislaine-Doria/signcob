import { readFile } from 'node:fs/promises';
import { chromium } from 'playwright';

function localUrl(value, path) {
  const url = new URL(value);
  if (url.protocol !== 'http:' || url.hostname !== '127.0.0.1' ||
      !url.port || url.pathname !== path || url.username || url.password ||
      url.search || url.hash) {
    throw new Error('Invalid isolated URL');
  }
  return url;
}

let browser;
let step = 'launch';
try {
  const fixture = JSON.parse(await readFile(process.argv[2], 'utf8'));
  const { manager, lawyerA, lawyerB } = fixture.users ?? {};
  const identities = Object.entries({ manager, lawyerA, lawyerB });
  if (fixture.environment !== 'signcob-isolated-e2e' ||
      fixture.database !== 'signcob_e2e' ||
      !identities.every(([role, user]) =>
        user?.email === `${role.toLowerCase()}@signcob-e2e.invalid` &&
        typeof user.password === 'string' && user.password.startsWith('Aa9!') &&
        typeof user.userId === 'string' &&
        /^[\da-f]{8}-(?:[\da-f]{4}-){3}[\da-f]{12}$/i.test(user.userId)) ||
      new Set(identities.map(([, user]) => user.userId.toLowerCase())).size !== 3) {
    throw new Error('Invalid isolated fixture');
  }
  const app = localUrl(fixture.webUrl, '/app/');
  const api = localUrl(fixture.apiUrl, '/');
  browser = await chromium.launch({
    executablePath: process.env.SIGNCOB_E2E_CHROME || undefined,
    proxy: { server: 'http://127.0.0.1:1', bypass: '127.0.0.1' },
  });
  const checkpoint = (name) => process.stdout.write(name + '\n');
  const clientsUrl = new URL('legalClient', api).href;
  async function newSession() {
    const context = await browser.newContext({
      viewport: { width: 1440, height: 900 },
      serviceWorkers: 'block',
    });
    await context.route('**/*', (route) => {
      const url = new URL(route.request().url());
      const allowed = url.origin === api.origin ||
        (url.origin === app.origin && url.pathname.startsWith('/app/'));
      return allowed ? route.continue() : route.abort();
    });
    await context.routeWebSocket('**/*', (socket) => socket.close());
    const page = await context.newPage();
    page.setDefaultTimeout(12_000);
    const button = (name) => page.getByRole('button', { name, exact: true });
    const text = (name) => page.getByText(name, { exact: true })
      .or(page.locator('flt-semantics').and(page.getByLabel(name, { exact: true })));
    const field = (name) => page.getByLabel(name, { exact: true });
    const open = async (url) => {
      const [config, response] = await Promise.all([
        page.waitForResponse(new URL('assets/assets/config.json', app).href),
        page.goto(url),
      ]);
      if (!response?.ok()) throw new Error('Web build did not load');
      if (!config.ok() || (await config.json()).apiUrl !== api.href) {
        throw new Error('Unexpected isolated API configuration');
      }
      // Flutter intentionally positions the accessibility switch offscreen.
      await page.locator('flt-semantics-placeholder').dispatchEvent('click');
    };
    const signIn = async (user) => {
      const previousStep = step;
      step = 'login-open';
      await button('Área administrativa').click();
      // Focus Flutter's active input before typing, as in the client edit.
      step = 'login-email';
      const email = field('E-mail');
      await email.click();
      await email.pressSequentially(user.email);
      step = 'login-password';
      const password = field('Senha');
      await password.click();
      await password.pressSequentially(user.password);
      step = 'login-request';
      const loginUrl = new URL('emailIdp', api).href;
      const isLogin = (request) => request.url() === loginUrl &&
        request.method() === 'POST' && request.postDataJSON()?.method === 'login';
      let requested = false;
      const observe = (request) => { if (isLogin(request)) requested = true; };
      page.on('request', observe);
      let response;
      try {
        [response] = await Promise.all([
          page.waitForResponse((result) => isLogin(result.request())),
          button('Entrar').click(),
        ]);
      } catch (error) {
        step = requested ? 'login-no-response' : 'login-no-request';
        throw error;
      } finally {
        page.off('request', observe);
      }
      step = 'login-rejected';
      if (!response.ok()) throw new Error('Login request failed');
      step = 'login-dashboard';
      await text('Área interna').waitFor();
      step = previousStep;
    };
    const clientResponse = (method) => page.waitForResponse((response) => {
      const request = response.request();
      return response.url() === clientsUrl &&
        request.method() === 'POST' && request.postDataJSON()?.method === method;
    });
    return { page, button, text, field, open, signIn, clientResponse };
  }

  const { page, button, text, field, open, signIn, clientResponse } = await newSession();
  step = 'open-web-build';
  await open(app.href);
  await button('Área administrativa').waitFor();
  checkpoint('web-build-loaded');
  await signIn(manager);
  checkpoint('signed-in');

  const initialName = 'Cliente sintético de navegador';
  const updatedName = 'Cliente sintético revisado';
  step = 'create';
  await button('Clientes').click();
  await text('Nenhum cliente encontrado.').waitFor();
  await button('Novo cliente').click();
  await field('Nome').fill(initialName);
  await button('Salvar cliente').click();
  await text(initialName).waitFor();
  checkpoint('client-created');

  step = 'open-edit';
  await button('Editar cliente').or(page.getByLabel('Editar cliente', { exact: true })).click();
  step = 'edit-name';
  const name = field('Nome');
  await name.click();
  await name.press('ControlOrMeta+a');
  await name.pressSequentially(updatedName);
  step = 'save-edit';
  const [updated] = await Promise.all([
    clientResponse('update'),
    button('Salvar cliente').click(),
  ]);
  step = 'edit-rejected';
  if (!updated.ok()) throw new Error('Update request failed');
  step = 'edit-value';
  if (updated.request().postDataJSON().name !== updatedName) {
    throw new Error('Unexpected update value');
  }
  const { id: clientId } = await updated.json();
  if (!Number.isInteger(clientId)) throw new Error('Missing client ID');
  step = 'show-update';
  await text(updatedName).waitFor();
  checkpoint('client-updated');

  // Re-enter the section to create a fresh widget and issue a new list call.
  step = 'reread';
  await button('Processos').click();
  await button('Clientes').click();
  await text(updatedName).waitFor();
  await text(initialName).waitFor({ state: 'hidden' });
  checkpoint('client-reloaded');

  async function assign(user) {
    await button('Atribuir advogado').or(field('Atribuir advogado')).click();
    const target = field('Identificador da conta do advogado');
    await target.click();
    await target.pressSequentially(user.userId);
    const [response] = await Promise.all([
      clientResponse('assign'),
      button('Confirmar').click(),
    ]);
    if (!response.ok()) throw new Error('Assignment failed');
    const row = await response.json();
    if (row.id !== clientId || row.assignedLawyerId !== user.userId) {
      throw new Error('Unexpected assignment result');
    }
    await text(updatedName).waitFor();
  }

  async function openLawyer(user) {
    const session = await newSession();
    await session.open(app.href);
    await session.signIn(user);
    return session;
  }

  async function checkVisibility(session, user, visible) {
    const [response] = await Promise.all([
      session.clientResponse('list'),
      session.button('Clientes').click(),
    ]);
    if (!response.ok()) throw new Error('Client list request failed');
    const rows = await response.json();
    if (!Array.isArray(rows) || (visible
      ? rows.length !== 1 || rows[0].id !== clientId ||
        rows[0].name !== updatedName || rows[0].assignedLawyerId !== user.userId
      : rows.length !== 0)) {
      throw new Error('Unexpected client list');
    }
    const empty = session.text('Nenhum cliente encontrado.');
    const record = session.text(updatedName);
    await (visible ? record : empty).waitFor();
    await (visible ? empty : record).waitFor({ state: 'hidden' });
  }

  step = 'assign-lawyer-a';
  await assign(lawyerA);
  checkpoint('client-assigned-lawyer-a');
  step = 'check-lawyer-a-before';
  const sessionA = await openLawyer(lawyerA);
  await checkVisibility(sessionA, lawyerA, true);
  checkpoint('lawyer-a-client-visible');
  step = 'check-lawyer-b-before';
  const sessionB = await openLawyer(lawyerB);
  await checkVisibility(sessionB, lawyerB, false);
  checkpoint('lawyer-b-client-hidden');

  step = 'assign-lawyer-b';
  await assign(lawyerB);
  checkpoint('client-reassigned-lawyer-b');
  step = 'check-lawyer-a-after';
  // Re-enter Clients with the same login to force a fresh list request.
  await sessionA.button('Processos').click();
  await checkVisibility(sessionA, lawyerA, false);
  checkpoint('lawyer-a-client-hidden');
  step = 'check-lawyer-b-after';
  await sessionB.button('Processos').click();
  await checkVisibility(sessionB, lawyerB, true);
  checkpoint('lawyer-b-client-visible');

  if (process.argv[3] === '--inject-failure') {
    process.exitCode = 23;
  } else {
    step = 'logout';
    await button('Sair').click();
    await button('Entrar').waitFor();
    await text('Área interna').waitFor({ state: 'hidden' });
    checkpoint('signed-out');

    // Revisit the protected route after navigating away and reloading.
    step = 'deny-access';
    await open(new URL('?after-logout=1', app).href);
    await button('Área administrativa').click();
    await button('Entrar').waitFor();
    await text('Área interna').waitFor({ state: 'hidden' });
    const status = await page.evaluate(async (url) => {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ method: 'list', offset: 0 }),
      });
      return response.status;
    }, clientsUrl);
    if (status !== 401) throw new Error('Anonymous list was not denied');
    checkpoint('internal-access-denied');
  }
} catch {
  // Playwright exceptions can contain fill arguments, headers and page content.
  process.stdout.write(`failed-${step}\n`);
  process.exitCode = 1;
} finally {
  try {
  await browser?.close();
  } catch {
  process.exitCode = 1;
  }
}
