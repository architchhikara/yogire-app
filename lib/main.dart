import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'home_screen.dart';
import 'domain/time_phase_provider.dart';
import 'data/task_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YogiReCompanionApp());
}

class YogiReCompanionApp extends StatelessWidget {
  const YogiReCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimePhaseProvider()),
        ChangeNotifierProvider(create: (_) => TaskRepository()),
      ],
      child: MaterialApp(
        title: 'Yogi Re Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
