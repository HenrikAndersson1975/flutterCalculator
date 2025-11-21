import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen.dart';
import 'package:flutter_calculator/theme/calculator_theme.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uträknare',
      debugShowCheckedModeBanner: false,
      theme: CalculatorTheme.light,
      home: const SafeArea(child: CalculatorScreen(title: 'Flutter-kalkylator')),
    );
  }   
}

 