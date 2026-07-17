import 'dart:io';

import 'package:args/args.dart';

import 'exceptions.dart';
import 'repository.dart';
import 'task.dart';
import 'task_comparator.dart';

/// CLI command handler for the task manager.
///
/// Follows DIP: depends on the [Repository<Task>] abstraction,
/// not on a concrete implementation. Sorting is delegated to
/// [TaskComparator] implementations (Strategy pattern).
class Cli {
  final Repository<Task> _repo;
  final ArgParser _parser = ArgParser();

  Cli(this._repo) {
    final addCmd = _parser.addCommand('add');
    addCmd.addOption('priority', abbr: 'p', allowed: ['low', 'medium', 'high'], defaultsTo: 'medium');
    addCmd.addOption('deadline', abbr: 'd');
    addCmd.addOption('urgent', abbr: 'u', defaultsTo: '0');
    final listCmd = _parser.addCommand('list');
    listCmd.addOption('sort', abbr: 's', allowed: ['priority', 'date'], defaultsTo: 'priority');
    _parser.addCommand('done');
    _parser.addCommand('delete');
  }

  void run(List<String> arguments) {
    if (arguments.isEmpty) {
      _printUsage();
      return;
    }
    final command = arguments[0];
    try {
      switch (command) {
        case 'add':
          _add(arguments.skip(1).toList());
        case 'list':
          _list(arguments.skip(1).toList());
        case 'done':
          _done(arguments.skip(1).toList());
        case 'delete':
          _delete(arguments.skip(1).toList());
        default:
          print('Unknown command: $command');
          _printUsage();
      }
    } on InvalidTaskException catch (e) {
      print('Error: ${e.message}');
      exit(1);
    } on TaskNotFoundException catch (e) {
      print('Error: ${e.message}');
      exit(1);
    }
  }

  void _add(List<String> args) {
    final results = _parser.commands['add']!.parse(args);
    if (results.rest.isEmpty) {
      throw InvalidTaskException('Title is required');
    }
    final title = results.rest.join(' ');
    final priority = Priority.values.firstWhere((p) => p.name == results['priority']);
    DateTime? deadline;
    if (results['deadline'] != null) {
      deadline = DateTime.tryParse(results['deadline'] as String);
      if (deadline == null) throw InvalidTaskException('Invalid date format. Use YYYY-MM-DD');
    }
    final escalationLevel = int.parse(results['urgent'] as String);
    final id = DateTime.now().millisecondsSinceEpoch.toRadixString(36);

    final Task task;
    if (escalationLevel > 0) {
      task = UrgentTask(id: id, title: title, priority: priority, deadline: deadline, escalationLevel: escalationLevel);
    } else {
      task = RegularTask(id: id, title: title, priority: priority, deadline: deadline);
    }
    _repo.add(task);
    print('Added: $title (id: $id)');
  }

  void _list(List<String> args) {
    final results = _parser.commands['list']!.parse(args);
    final tasks = _repo.getAll();
    if (tasks.isEmpty) {
      print('No tasks.');
      return;
    }

    final sortBy = results['sort'] as String;
    final TaskComparator comparator = switch (sortBy) {
      'date' => DateComparator(),
      _ => PriorityComparator(),
    };

    final sorted = List<Task>.from(tasks)..sort(comparator.compare);
    for (final task in sorted) {
      final status = task.isDone ? '[x]' : '[ ]';
      final deadlineStr = task.deadline != null ? ' (due: ${task.deadline!.toLocal().toString().split(' ')[0]})' : '';
      final extra = task is UrgentTask ? ' [escalation: ${task.escalationLevel}${task.isEscalated ? ' ESCALATED' : ''}]' : '';
      print('$status ${task.id} | ${task.title} | ${task.priority.name}$deadlineStr$extra');
    }
  }

  void _done(List<String> args) {
    if (args.isEmpty) throw InvalidTaskException('Task ID is required');
    final task = _repo.getById(args[0]);
    task.isDone = true;
    _repo.update(task);
    print('Marked as done: ${task.title}');
  }

  void _delete(List<String> args) {
    if (args.isEmpty) throw InvalidTaskException('Task ID is required');
    final task = _repo.getById(args[0]);
    _repo.remove(args[0]);
    print('Deleted: ${task.title}');
  }

  void _printUsage() {
    print('Usage: dart run bin/ffsc_cli_task_manager.dart <command> [options]');
    print('');
    print('Commands:');
    print('  add <title> [-p priority] [-d deadline] [-u escalation]');
    print('  list [-s priority|date]');
    print('  done <id>');
    print('  delete <id>');
  }
}

