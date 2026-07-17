import 'package:ffsc_cli_task_manager/task.dart';
import 'package:ffsc_cli_task_manager/task_factory.dart';
import 'package:test/test.dart';

void main() {
  test('UrgentTask serialization preserves escalationLevel and type', () {
    final task = UrgentTask(
      id: 'u3',
      title: 'Deploy hotfix',
      priority: Priority.high,
      deadline: DateTime(2026, 7, 20),
      escalationLevel: 5,
    );

    final json = task.toJson();
    expect(json['type'], 'urgent');
    expect(json['escalationLevel'], 5);

    final restored = TaskFactory.fromJson(json);
    expect(restored, isA<UrgentTask>());
    final urgent = restored as UrgentTask;
    expect(urgent.escalationLevel, 5);
    expect(urgent.isEscalated, isTrue);
    expect(urgent.deadline, DateTime(2026, 7, 20));
  });

  test('RegularTask serialization produces type regular', () {
    final task = RegularTask(
      id: 'r1',
      title: 'Write docs',
      priority: Priority.low,
    );

    final json = task.toJson();
    expect(json['type'], 'regular');
    expect(json.containsKey('escalationLevel'), isFalse);

    final restored = TaskFactory.fromJson(json);
    expect(restored, isA<RegularTask>());
  });
}
