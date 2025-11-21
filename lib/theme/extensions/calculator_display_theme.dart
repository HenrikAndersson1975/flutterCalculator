import 'package:flutter/material.dart';

@immutable
class CalculatorDisplayTheme extends ThemeExtension<CalculatorDisplayTheme> {
  final Color displayColor;
  final Color borderColor;
  final Color displayAlertColor;
  final Color borderAlertColor;

  final Color largeTextColor;
  final Color smallTextColor;
  final Color memoryIndicatorColor;

  const CalculatorDisplayTheme({
    required this.displayColor,
    required this.displayAlertColor,
    required this.borderColor,
    required this.borderAlertColor,
    required this.largeTextColor,
    required this.smallTextColor,
    required this.memoryIndicatorColor,  
  });

  @override
  CalculatorDisplayTheme copyWith({
    Color? displayColor,
    Color? borderColor,
    Color? displayAlertColor,
    Color? borderAlertColor,
    Color? largeTextColor,
    Color? smallTextColor,
    Color? memoryIndicatorColor,
  }) {
    return CalculatorDisplayTheme(
      displayColor: displayColor ?? this.displayColor,
      displayAlertColor: displayAlertColor ?? this.displayAlertColor,
      borderColor: borderColor ?? this.borderColor,
      borderAlertColor: borderAlertColor ?? this.borderAlertColor,
      largeTextColor: largeTextColor ?? this.largeTextColor,
      smallTextColor: smallTextColor ?? this.smallTextColor,
      memoryIndicatorColor: memoryIndicatorColor ?? this.memoryIndicatorColor,
    );
  }

  @override
  ThemeExtension<CalculatorDisplayTheme> lerp(
    covariant ThemeExtension<CalculatorDisplayTheme>? other,
    double t,
  ) {
    if (other is! CalculatorDisplayTheme) return this;
    return t < 0.5 ? this : other;
  }
}
