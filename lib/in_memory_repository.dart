import 'exceptions.dart';
import 'repository.dart';
import 'task.dart';

/// In-memory implementation of [Repository<T>].
///
/// Useful for testing without requiring file I/O, demonstrating
/// the power of the generic [Repository] interface.
class InMemoryRepository<T extends Task> implements Repository<T> {
  final List<T> _tasks = [];

  @override
  void add(T item) {
    _tasks.add(item);
  }

  @override
  List<T> getAll() => List.unmodifiable(_tasks);

  @override
  T getById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      throw TaskNotFoundException('Task not found: $id');
    }
  }

  @override
  void update(T item) {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) throw TaskNotFoundException('Task not found: ${item.id}');
    _tasks[index] = item;
  }

  @override
  void remove(String id) {
    final before = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    if (_tasks.length == before) throw TaskNotFoundException('Task not found: $id');
  }
}
