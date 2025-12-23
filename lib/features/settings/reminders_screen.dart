import 'package:flutter/material.dart';
import '../../core/notification_service.dart';
import '../../data/ekadashi_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _waterReminder = false;
  bool _ekadashiReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Water Reminder"),
            subtitle: const Text("Remind every 2 hours"),
            value: _waterReminder,
            activeColor: Colors.orange,
            onChanged: (val) {
              setState(() => _waterReminder = val);
              if (val) _scheduleWaterReminders();
              else _cancelWaterReminders();
            },
          ),
          SwitchListTile(
            title: const Text("Ekadashi Reminder"),
            subtitle: const Text("Notify on upcoming Ekadashi"),
            value: _ekadashiReminder,
            activeColor: Colors.orange,
            onChanged: (val) {
              setState(() => _ekadashiReminder = val);
              if (val) _scheduleEkadashiReminders();
              else _cancelEkadashiReminders(); // Need specific ID cancellation logic
            },
          ),
        ],
      ),
    );
  }

  void _scheduleWaterReminders() {
    // Schedule repeating reminders starting 2 hours from now, then periodically.
    // For simplicity in this demo, we schedule 3 notifications.
    final now = DateTime.now();
    for (int i = 1; i <= 3; i++) {
      NotificationService().scheduleNotification(
        id: 200 + i,
        title: "Water Time",
        body: "Drink warm water with honey/turmeric.",
        scheduledDate: now.add(Duration(hours: 2 * i)),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Water reminders set for the next 6 hours")));
  }

  void _cancelWaterReminders() {
    // Cancel the 3 hardcoded notifications
    for (int i = 1; i <= 3; i++) {
      NotificationService().cancelNotification(200 + i);
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Water reminders cancelled")));
  }

  void _scheduleEkadashiReminders() {
    final upcoming = EkadashiService.getUpcomingEkadashis();
    if (upcoming.isNotEmpty) {
      final next = upcoming.first;
      // Schedule for 6 AM on that day
      final scheduledTime = DateTime(next.year, next.month, next.day, 6, 0);

      NotificationService().scheduleNotification(
        id: 300,
        title: "Ekadashi Today",
        body: "Observe fasting or light diet today.",
        scheduledDate: scheduledTime,
      );
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder set for next Ekadashi: ${next.day}/${next.month}")));
    }
  }

  void _cancelEkadashiReminders() {
    NotificationService().cancelNotification(300);
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ekadashi reminders cancelled")));
  }
}
