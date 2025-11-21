import 'package:flutter/material.dart';
import 'package:flutter_calculator/theme/extensions/calculator_buttons_theme.dart';
import 'package:flutter_calculator/theme/extensions/calculator_display_theme.dart';

@immutable
class CalculatorAppTheme extends ThemeExtension<CalculatorAppTheme> {
  final Color calculatorBackgroundColor;
  final CalculatorDisplayTheme display;
  final CalculatorButtonsTheme buttons;

  const CalculatorAppTheme({
    required this.calculatorBackgroundColor,
    required this.display,
    required this.buttons,
  });

  @override
  CalculatorAppTheme copyWith({
    Color? calculatorBackgroundColor,
    CalculatorDisplayTheme? display,
    CalculatorButtonsTheme? buttons,
  }) {
    return CalculatorAppTheme(
      calculatorBackgroundColor:
          calculatorBackgroundColor ?? this.calculatorBackgroundColor,
      display: display ?? this.display,
      buttons: buttons ?? this.buttons,
    );
  }

  @override
  CalculatorAppTheme lerp(ThemeExtension<CalculatorAppTheme>? other, double t) {
    if (other is! CalculatorAppTheme) return this;
    return t < 0.5 ? this : other;
  }
}
