import 'package:ffsc_cli_task_manager/task.dart';
import 'package:test/test.dart';

void main() {
  test('isEscalated is true when escalationLevel > 1', () {
    final task = UrgentTask(
      id: 'u1',
      title: 'Critical fix',
      priority: Priority.high,
      escalationLevel: 3,
    );
    expect(task.isEscalated, isTrue);
  });

  test('isEscalated is false when escalationLevel is 1', () {
    final task = UrgentTask(
      id: 'u2',
      title: 'Minor urgent',
      priority: Priority.medium,
      escalationLevel: 1,
    );
    expect(task.isEscalated, isFalse);
  });
}
