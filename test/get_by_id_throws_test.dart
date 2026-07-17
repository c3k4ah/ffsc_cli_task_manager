import 'dart:io';

import 'package:ffsc_cli_task_manager/exceptions.dart';
import 'package:ffsc_cli_task_manager/repository.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late JsonRepository repo;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('task_test_');
    repo = JsonRepository(tempDir.path);
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('get by id throws TaskNotFoundException', () {
    expect(
      () => repo.getById('nonexistent'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });
}
