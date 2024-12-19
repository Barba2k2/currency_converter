import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'src/app_widget.dart';

void main() {
  runApp(const MainApp());
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
