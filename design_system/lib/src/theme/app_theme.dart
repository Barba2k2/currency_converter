import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../design_system.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.25,
      ),
      bodyMedium: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      bodySmall: GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
    ),
  );
}
