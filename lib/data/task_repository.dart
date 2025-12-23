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

  // Gamification Logic

  /// Calculates the current streak of consecutive days where at least 50% of tasks were completed.
  Future<int> calculateCurrentStreak() async {
    final db = await _dbHelper.database;
    int streak = 0;
    DateTime date = DateTime.now();

    while (true) {
      final dateString = date.toIso8601String().split('T')[0];
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'date LIKE ?',
        whereArgs: ['$dateString%'],
      );

      if (maps.isEmpty) {
        // If it's today, we continue to check yesterday without breaking streak (as today might not be done yet)
        if (DateTime.now().difference(date).inDays > 0) {
          // If it's a past day and no data/tasks, streak is broken.
          break;
        }
      } else {
        int completedCount = maps.where((t) => t['isCompleted'] == 1).length;
        int totalCount = maps.length;

        // Logic: Streak counts if >= 50% tasks done
        if (totalCount > 0 && (completedCount / totalCount) >= 0.5) {
          streak++;
        } else {
          // If criteria not met:
          // If it's today, we ignore and continue to yesterday (allow incomplete today).
          // If it's yesterday or before, streak breaks.
          if (DateTime.now().difference(date).inDays > 0) {
             break;
          }
        }
      }
      date = date.subtract(const Duration(days: 1));
      // Safety break for loop
      if (streak > 365) break;
    }
    return streak;
  }

  /// Returns completion percentage (0.0 to 1.0) for the last [days] days.
  /// Index 0 is today, Index 6 is 7 days ago.
  Future<List<double>> getCompletionHistory(int days) async {
    final db = await _dbHelper.database;
    List<double> history = [];
    DateTime date = DateTime.now();

    for (int i = 0; i < days; i++) {
      final dateString = date.subtract(Duration(days: i)).toIso8601String().split('T')[0];
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'date LIKE ?',
        whereArgs: ['$dateString%'],
      );

      if (maps.isEmpty) {
        history.add(0.0);
      } else {
        int completedCount = maps.where((t) => t['isCompleted'] == 1).length;
        history.add(completedCount / maps.length);
      }
    }
    return history; // [Today, Yesterday, ...]
  }
}
