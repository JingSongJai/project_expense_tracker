import 'package:expanse_tracker/data/constant.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Kantumruy',
  colorScheme: ColorScheme.dark(
    primary: Constant.primaryColor,
    surface: const Color(0xFF121212), // A dark surface color
    secondary: Colors.grey[900]!, // Dark secondary background
  ),
  scaffoldBackgroundColor: const Color(
    0xFF121212,
  ), // Optional: sets overall app background
  cardColor: const Color(0xFF1E1E2E), // Optional: dark card background
);
