import 'package:flutter/material.dart';

import 'package:design_system/design_system.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'presentation/home.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Home(),
    );
  }
}
