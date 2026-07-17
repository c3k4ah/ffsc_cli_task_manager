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

  test('update task', () {
    final task = RegularTask(
      id: '1',
      title: 'Original',
      priority: Priority.low,
    );
    repo.add(task);
    task.title = 'Updated';
    task.isDone = true;
    repo.update(task);
    final updated = repo.getById('1');
    expect(updated.title, 'Updated');
    expect(updated.isDone, isTrue);
  });
}
