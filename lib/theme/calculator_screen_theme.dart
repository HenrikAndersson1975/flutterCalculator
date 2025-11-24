import 'package:flutter/material.dart';
import 'package:flutter_calculator/theme/calculator_buttons_theme.dart';
import 'package:flutter_calculator/theme/calculator_display_theme.dart';

@immutable
class CalculatorScreenTheme extends ThemeExtension<CalculatorScreenTheme> {
  final Color backgroundColor;
  final CalculatorDisplayTheme display;
  final CalculatorButtonsTheme buttons;

  const CalculatorScreenTheme({
    required this.backgroundColor,
    required this.display,
    required this.buttons,
  });

  @override
  CalculatorScreenTheme copyWith({
    Color? backgroundColor,
    CalculatorDisplayTheme? display,
    CalculatorButtonsTheme? buttons,
  }) {
    return CalculatorScreenTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      display: display ?? this.display,
      buttons: buttons ?? this.buttons,
    );
  }

  @override
  CalculatorScreenTheme lerp(ThemeExtension<CalculatorScreenTheme>? other, double t) {
    if (other is! CalculatorScreenTheme) return this;
    return t < 0.5 ? this : other;
  }
}