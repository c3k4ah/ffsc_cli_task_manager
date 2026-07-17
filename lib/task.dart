enum Priority { low, medium, high }

/// Abstract base class defining the data contract for all tasks.
///
/// Follows SRP: this class only holds state and declares the
/// serialization contract ([toJson]). Deserialization is handled
/// by [TaskFactory] and sorting by [TaskComparator].
abstract class Task {
  final String id;
  String title;
  Priority priority;
  DateTime? deadline;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });

  Map<String, dynamic> toJson();
}


class RegularTask extends Task {
  RegularTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'regular',
    'id': id,
    'title': title,
    'priority': priority.name,
    'deadline': deadline?.toIso8601String(),
    'isDone': isDone,
  };

  factory RegularTask.fromJson(Map<String, dynamic> json) => RegularTask(
    id: json['id'] as String,
    title: json['title'] as String,
    priority: Priority.values.firstWhere((p) => p.name == json['priority']),
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
    isDone: json['isDone'] as bool,
  );
}

class UrgentTask extends Task {
  final int escalationLevel;

  bool get isEscalated => escalationLevel > 1;

  UrgentTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
    this.escalationLevel = 1,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'urgent',
    'id': id,
    'title': title,
    'priority': priority.name,
    'deadline': deadline?.toIso8601String(),
    'isDone': isDone,
    'escalationLevel': escalationLevel,
  };

  factory UrgentTask.fromJson(Map<String, dynamic> json) => UrgentTask(
    id: json['id'] as String,
    title: json['title'] as String,
    priority: Priority.values.firstWhere((p) => p.name == json['priority']),
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
    isDone: json['isDone'] as bool,
    escalationLevel: json['escalationLevel'] as int,
  );
}
