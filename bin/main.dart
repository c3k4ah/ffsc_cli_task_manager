import 'dart:io';

import 'package:ffsc_cli_task_manager/cli.dart';
import 'package:ffsc_cli_task_manager/repository.dart';

void main(List<String> arguments) {
  final dir = Directory.current.path;
  final repo = JsonRepository(dir);
  Cli(repo).run(arguments);
}
