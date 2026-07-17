/// Thrown when a requested task cannot be found in the repository.
class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);
}

/// Thrown when a task is invalid (e.g., missing title, bad date format).
class InvalidTaskException implements Exception {
  final String message;
  InvalidTaskException(this.message);
}

