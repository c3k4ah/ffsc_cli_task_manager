import 'dart:io';

import 'package:ffsc_cli_task_manager/repository.dart';
import 'package:ffsc_cli_task_manager/task.dart';
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

  test('add and get all tasks', () {
    repo.add(RegularTask(id: '1', title: 'Test task', priority: Priority.low));
    final tasks = repo.getAll();
    expect(tasks.length, 1);
    expect(tasks[0].title, 'Test task');
    expect(tasks[0].priority, Priority.low);
  });
}
