import 'dart:io';

import 'package:ffsc_cli_task_manager/exceptions.dart';
import 'package:ffsc_cli_task_manager/repository.dart';
import 'package:ffsc_cli_task_manager/task.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late JsonRepository repo;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('task_exc_test_');
    repo = JsonRepository(tempDir.path);
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('getById throws TaskNotFoundException for missing id', () {
    expect(
      () => repo.getById('nonexistent'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('remove throws TaskNotFoundException for missing id', () {
    expect(
      () => repo.remove('nonexistent'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('update throws TaskNotFoundException for missing id', () {
    final task = RegularTask(id: 'ghost', title: 'Gone', priority: Priority.low);
    expect(
      () => repo.update(task),
      throwsA(isA<TaskNotFoundException>()),
    );
  });
}
