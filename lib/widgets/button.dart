import 'package:flutter/material.dart';
import 'package:flutter_calculator/theme/calculator_app_theme.dart';
import 'package:flutter_calculator/theme/extensions/calculator_buttons_theme.dart';

enum ButtonFunction { number, operator, memory, other }

class Button extends StatefulWidget {
  final String label;
  final Function(String) onPressed;
  final ButtonFunction buttonFunction;
  final bool isDisabled;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    required this.buttonFunction,
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
    ).extension<CalculatorAppTheme>()!.buttons;

    final Color backgroundColor = switch (widget.buttonFunction) {
      ButtonFunction.operator => theme.operatorBackgroundColor,
      ButtonFunction.memory => theme.memoryBackgroundColor,
      ButtonFunction.number => theme.digitBackgroundColor,
      ButtonFunction.other => theme.otherBackgroundColor,
    };

    final Color textColor = switch (widget.buttonFunction) {
      ButtonFunction.operator => theme.operatorTextColor,
      ButtonFunction.memory => theme.memoryTextColor,
      ButtonFunction.number => theme.digitTextColor,
      ButtonFunction.other => theme.otherTextColor,
    };

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
              widget.label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
