import 'package:flutter/material.dart';
import 'package:flutter_calculator/theme/calculator_screen_theme.dart';
import 'package:flutter_calculator/theme/calculator_buttons_theme.dart';
import 'package:flutter_calculator/utils/input_extensions.dart';

enum ButtonFunction { number, operator, memory, other }

class Button extends StatefulWidget {
  final String label;
  final Function(String) onPressed;
  final bool isDisabled;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isPressed = false;

  void _onTap() {
    if (widget.isDisabled) return;

    setState(() {
      _isPressed = true;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isPressed = false;
      });
    });

    widget.onPressed(widget.label);  
  }

  @override
  Widget build(BuildContext context) {
    CalculatorButtonsTheme theme = Theme.of(
      context,
    ).extension<CalculatorScreenTheme>()!.buttons;

    String buttonText = widget.label;
    Color backgroundColor = _getBackgroundColor(buttonText, theme);
    Color textColor = _getTextColor(buttonText, theme);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fontSize = constraints.maxHeight / 3;

        return GestureDetector(
          onTap: widget.isDisabled ? null : _onTap,
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                /*boxShadow:           
                        [
                            BoxShadow(
                              offset: const Offset(0, 2), 
                              blurRadius: 4, 
                              color: Colors.black,
                            ),
                          ],*/
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getTextColor(String buttonText, CalculatorButtonsTheme theme) {
    Color textColor;
    if (buttonText.isDigit() || buttonText.isDecimalPoint()) {
      textColor = theme.numberTextColor;
    } else if (buttonText.isParenthesis() || buttonText.isOperator()) {
      textColor = theme.operatorTextColor;
    } else if (buttonText.isMemory()) {
      textColor = theme.memoryTextColor;
    } else {
      textColor = theme.otherTextColor;
    }
    return textColor;
  }

  Color _getBackgroundColor(String buttonText, CalculatorButtonsTheme theme) {
    Color backgroundColor;
    if (buttonText.isDigit() || buttonText.isDecimalPoint()) {
      backgroundColor = theme.numberBackgroundColor;
    } else if (buttonText.isParenthesis() || buttonText.isOperator()) {
      backgroundColor = theme.operatorBackgroundColor;
    } else if (buttonText.isMemory()) {
      backgroundColor = theme.memoryBackgroundColor;
    } else {
      backgroundColor = theme.otherBackgroundColor;
    }
    return backgroundColor;
  }
}
