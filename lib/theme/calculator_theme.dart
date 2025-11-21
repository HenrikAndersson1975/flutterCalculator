// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'calculator_app_theme.dart';
import 'extensions/calculator_buttons_theme.dart';
import 'extensions/calculator_display_theme.dart';

class CalculatorTheme {
  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 212, 219, 211),
    extensions: <ThemeExtension<dynamic>>[
      const CalculatorAppTheme(
        calculatorBackgroundColor: Color.fromARGB(255, 112, 109, 109),
        display: CalculatorDisplayTheme(
          displayColor: Colors.white,
          displayAlertColor: Colors.red,
          borderColor: Colors.black,
          borderAlertColor: Colors.red,
          largeTextColor: Colors.black,
          smallTextColor: Colors.black,
          memoryIndicatorColor: Colors.black,
        ),
        buttons: CalculatorButtonsTheme(
          digitBackgroundColor: Color.fromARGB(255, 52, 49, 49),
          digitTextColor: Color.fromARGB(255, 255, 255, 255),
          operatorBackgroundColor: Color.fromARGB(255, 246, 162, 5),
          operatorTextColor: Color.fromARGB(255, 31, 29, 29),
          memoryBackgroundColor: Color.fromARGB(255, 210, 232, 217),
          memoryTextColor: Color.fromARGB(255, 31, 29, 29),
          otherBackgroundColor: Color.fromARGB(255, 152, 149, 149),
          otherTextColor: Color.fromARGB(255, 31, 29, 29),
        ),
      ),
    ],
  );

  // Lägg ev till dark 
}