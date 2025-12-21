import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/task_repository.dart';

class DwijasScreen extends StatefulWidget {
  const DwijasScreen({super.key});

  @override
  State<DwijasScreen> createState() => _DwijasScreenState();
}

class _DwijasScreenState extends State<DwijasScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskRepository>(context, listen: false).loadTasks(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dwijas Daily Routine"),
      ),
      body: Column(
        children: [
          // Date Selector (simplified)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                    });
                    Provider.of<TaskRepository>(context, listen: false).loadTasks(_selectedDate);
                  },
                ),
                Text(
                  DateFormat('EEE, MMM d').format(_selectedDate),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                    });
                    Provider.of<TaskRepository>(context, listen: false).loadTasks(_selectedDate);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<TaskRepository>(
              builder: (context, repository, child) {
                if (repository.tasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: repository.tasks.length,
                  itemBuilder: (context, index) {
                    final task = repository.tasks[index];
                    return CheckboxListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      value: task.isCompleted,
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        repository.toggleTask(task);
                      },
                      secondary: _getIconForTask(task.title),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Icon _getIconForTask(String title) {
    if (title.toLowerCase().contains('wake')) return const Icon(Icons.access_alarm);
    if (title.toLowerCase().contains('bath')) return const Icon(Icons.bathtub);
    if (title.toLowerCase().contains('lamp')) return const Icon(Icons.lightbulb);
    if (title.toLowerCase().contains('water')) return const Icon(Icons.local_drink);
    if (title.toLowerCase().contains('sadhana')) return const Icon(Icons.self_improvement);
    return const Icon(Icons.check_circle_outline);
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Habit"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter habit name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<TaskRepository>(context, listen: false)
                      .addTask(controller.text, _selectedDate);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
