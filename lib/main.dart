import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'src/app_widget.dart';
import 'src/core/application_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationConfig().consfigureApp();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppWidget(),
    );
  }
}
