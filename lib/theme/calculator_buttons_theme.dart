import 'package:flutter/material.dart';

@immutable
class CalculatorButtonsTheme extends ThemeExtension<CalculatorButtonsTheme>
{
  final Color numberBackgroundColor;
  final Color numberTextColor;

  final Color operatorBackgroundColor;
  final Color operatorTextColor;

  final Color memoryBackgroundColor;
  final Color memoryTextColor;

  final Color otherBackgroundColor;
  final Color otherTextColor;


  const CalculatorButtonsTheme({
    required this.numberBackgroundColor,
    required this.numberTextColor,
    required this.operatorBackgroundColor,
    required this.operatorTextColor,
    required this.memoryBackgroundColor,
    required this.memoryTextColor,
    required this.otherBackgroundColor,
    required this.otherTextColor,
  });

  @override
  CalculatorButtonsTheme copyWith({
    Color? numberBackgroundColor,
    Color? numberTextColor,
    Color? operatorBackgroundColor,
    Color? operatorTextColor,
    Color? memoryBackgroundColor,
    Color? memoryTextColor,
    Color? otherBackgroundColor,
    Color? otherTextColor,
  }) {
    return CalculatorButtonsTheme(
      numberBackgroundColor: numberBackgroundColor ?? this.numberBackgroundColor,
      numberTextColor: numberTextColor ?? this.numberTextColor,
      operatorBackgroundColor: operatorBackgroundColor ?? this.operatorBackgroundColor,
      operatorTextColor: operatorTextColor ?? this.operatorTextColor,
      memoryBackgroundColor: memoryBackgroundColor ?? this.memoryBackgroundColor,
      memoryTextColor: memoryTextColor ?? this.memoryTextColor,
      otherBackgroundColor: otherBackgroundColor ?? this.otherBackgroundColor,
      otherTextColor: otherTextColor ?? this.otherTextColor,
    );
  }

  @override
  ThemeExtension<CalculatorButtonsTheme> lerp(covariant ThemeExtension<CalculatorButtonsTheme>? other, double t) {
      if (other is! CalculatorButtonsTheme) return this;   
    return t < 0.5 ? this : other;
  }
}