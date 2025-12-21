import 'package:flutter/foundation.dart';
import 'database_helper.dart';
import '../domain/task_model.dart';

class TaskRepository extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks(DateTime date) async {
    final db = await _dbHelper.database;
    // Filter by date (ignoring time)
    final dateString = date.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'date LIKE ?',
      whereArgs: ['$dateString%'],
    );

    _tasks = List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });

    // If no tasks exist for today, initialize defaults
    if (_tasks.isEmpty) {
      await _initializeDefaultTasks(date);
    }

    notifyListeners();
  }

  Future<void> _initializeDefaultTasks(DateTime date) async {
    final defaults = [
      'Wake up before sunrise',
      'Cold Water Bath',
      'Light a Lamp',
      'Consume Warm Water with Honey',
      'Morning Sadhana',
    ];

    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var title in defaults) {
      final task = Task(title: title, date: date);
      batch.insert('tasks', task.toMap());
    }
    await batch.commit();
    await loadTasks(date);
  }

  Future<void> addTask(String title, DateTime date) async {
    final db = await _dbHelper.database;
    final task = Task(title: title, date: date);
    await db.insert('tasks', task.toMap());
    await loadTasks(date);
  }

  Future<void> toggleTask(Task task) async {
    final db = await _dbHelper.database;
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await db.update(
      'tasks',
      updatedTask.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    await loadTasks(task.date);
  }
}
