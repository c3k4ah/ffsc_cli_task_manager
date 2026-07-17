import 'exceptions.dart';
import 'task.dart';

/// Factory responsible for creating [Task] instances from JSON.
///
/// Follows SRP: deserialization dispatch logic is separated from the
/// domain model. The abstract [Task] class no longer needs to know
/// about its concrete subtypes.
class TaskFactory {
  /// Creates a [Task] from a JSON map by dispatching on the `type` field.
  static Task fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    return switch (type) {
      'regular' => RegularTask.fromJson(json),
      'urgent' => UrgentTask.fromJson(json),
      _ => throw InvalidTaskException('Unknown task type: $type'),
    };
  }
}
