import 'task.dart';

/// Strategy interface for comparing tasks.
///
/// Follows OCP: new sorting strategies can be added by implementing
/// this interface without modifying existing comparators.
abstract interface class TaskComparator {
  int compare(Task a, Task b);
}

/// Sorts tasks by priority (high first), then by deadline (earliest first),
/// then alphabetically by title.
class PriorityComparator implements TaskComparator {
  @override
  int compare(Task a, Task b) {
    if (a.priority.index != b.priority.index) {
      return b.priority.index.compareTo(a.priority.index);
    }
    if (a.deadline != null && b.deadline != null) {
      return a.deadline!.compareTo(b.deadline!);
    }
    if (a.deadline != null) return -1;
    if (b.deadline != null) return 1;
    return a.title.compareTo(b.title);
  }
}

/// Sorts tasks by deadline (earliest first). Tasks without a deadline
/// are placed last, then sorted alphabetically by title.
class DateComparator implements TaskComparator {
  @override
  int compare(Task a, Task b) {
    if (a.deadline != null && b.deadline != null) {
      return a.deadline!.compareTo(b.deadline!);
    }
    if (a.deadline != null) return -1;
    if (b.deadline != null) return 1;
    return a.title.compareTo(b.title);
  }
}
