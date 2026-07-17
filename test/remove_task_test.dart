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

  test('remove task', () {
    repo.add(
      RegularTask(id: '1', title: 'To delete', priority: Priority.medium),
    );
    repo.remove('1');
    expect(repo.getAll(), isEmpty);
  });
}
