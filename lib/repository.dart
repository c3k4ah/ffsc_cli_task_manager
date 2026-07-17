import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'exceptions.dart';
import 'task.dart';
import 'task_factory.dart';

/// Generic repository contract.
///
/// Uses Dart 3 [interface class] to enforce that implementations
/// must use [implements], not [extends]. Follows ISP by exposing
/// only essential CRUD operations.
interface class Repository<T> {
  void add(T item) {}
  List<T> getAll() => [];
  T getById(String id) => throw UnimplementedError();
  void update(T item) {}
  void remove(String id) {}
}

/// File-backed JSON implementation of [Repository<Task>].
///
/// Follows DIP: consumers depend on the [Repository<Task>] abstraction,
/// not on this concrete class.
class JsonRepository implements Repository<Task> {
  final String _path;
  List<Task> _tasks = [];

  JsonRepository(String dir)
    : _path = p.join(dir, 'tasks.json') {
    _load();
  }

  void _load() {
    final file = File(_path);
    if (!file.existsSync()) {
      _tasks = [];
      return;
    }
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) {
      _tasks = [];
      return;
    }
    final List<dynamic> json = jsonDecode(content);
    _tasks = json.map((e) => TaskFactory.fromJson(e as Map<String, dynamic>)).toList();
  }

  void _save() {
    final file = File(_path);
    file.writeAsStringSync(jsonEncode(_tasks.map((t) => t.toJson()).toList()));
  }

  @override
  void add(Task item) {
    _tasks.add(item);
    _save();
  }

  @override
  List<Task> getAll() => List.unmodifiable(_tasks);

  @override
  Task getById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      throw TaskNotFoundException('Task not found: $id');
    }
  }

  @override
  void update(Task item) {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) throw TaskNotFoundException('Task not found: ${item.id}');
    _tasks[index] = item;
    _save();
  }

  @override
  void remove(String id) {
    final before = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    if (_tasks.length == before) throw TaskNotFoundException('Task not found: $id');
    _save();
  }
}

