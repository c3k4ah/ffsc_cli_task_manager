import 'package:ffsc_cli_task_manager/task.dart';
import 'package:ffsc_cli_task_manager/task_factory.dart';
import 'package:test/test.dart';

void main() {
  test('task serialization round trip', () {
    final task = UrgentTask(
      id: 'abc',
      title: 'Urgent thing',
      priority: Priority.high,
      deadline: DateTime(2026, 12, 31),
      escalationLevel: 3,
    );
    final json = task.toJson();
    final restored = TaskFactory.fromJson(json);
    expect(restored, isA<UrgentTask>());
    expect(restored.id, 'abc');
    expect(restored.title, 'Urgent thing');
    expect((restored as UrgentTask).escalationLevel, 3);
    expect(restored.deadline, DateTime(2026, 12, 31));
  });
}

