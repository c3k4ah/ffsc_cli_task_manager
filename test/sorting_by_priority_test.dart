import 'package:ffsc_cli_task_manager/in_memory_repository.dart';
import 'package:ffsc_cli_task_manager/task.dart';
import 'package:ffsc_cli_task_manager/task_comparator.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryRepository<Task> repo;

  setUp(() {
    repo = InMemoryRepository<Task>();
  });

  test('task sorting by priority then deadline', () {
    repo.add(RegularTask(id: '1', title: 'Low', priority: Priority.low));
    repo.add(RegularTask(id: '2', title: 'High', priority: Priority.high));
    repo.add(RegularTask(id: '3', title: 'Medium', priority: Priority.medium));
    final tasks = List<Task>.from(repo.getAll())
      ..sort(PriorityComparator().compare);
    expect(tasks.map((t) => t.priority).toList(), [
      Priority.high,
      Priority.medium,
      Priority.low,
    ]);
  });
}


