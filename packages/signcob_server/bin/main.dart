import 'package:signcob_server/server.dart';
import 'package:signcob_server/src/config/local_env.dart';

/// This is the starting point for your Serverpod server. Typically, there is
/// no need to modify this file.
void main(List<String> args) {
  LocalEnv.load();
  run(args);
}
