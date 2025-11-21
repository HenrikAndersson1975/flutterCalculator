import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen_logic.dart';
import 'package:flutter_calculator/theme/calculator_app_theme.dart';
import 'package:flutter_calculator/widgets/display.dart';
import 'package:flutter_calculator/widgets/keyboard.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.title});
  final String title;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorScreenLogic logic;

  Timer? _timer;
  bool _keyboardError = false;
  bool _showMemoryIndicator = false;

  @override
  void initState() {
    super.initState();
    logic = CalculatorScreenLogic(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //
  void onKeyboardButtonPressed(String buttonText) {
    setState(() {
      logic.keyboardButtonPressed(buttonText);

      _showMemoryIndicator = logic.hasMemory;

      if (!logic.isValid) {
        _triggerKeyboardErrorIndication();
      } else if (logic.hasMemory && logic.memoryValueChanged) {
        _triggerMemoryUpdatedIndication();
      }
    });
  }

  void _triggerKeyboardErrorIndication() {
    _keyboardError = true;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _keyboardError = false;
        });
      }
    });
  }

  void _triggerMemoryUpdatedIndication() {
    _showMemoryIndicator = false;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showMemoryIndicator = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isLandscape = screenWidth > screenHeight;
    int displayHeightRatio;
    int keyboardHeightRatio;

    double maxWidth, minWidth;
    double maxHeight, minHeight;
    {
      if (isLandscape) {
        // landscape
        displayHeightRatio = 2;
        keyboardHeightRatio = 3;

        maxWidth = 1000;
        minWidth = min(500, screenWidth);
        maxHeight = 800;
        minHeight = min(500, screenHeight);
      } else {
        // portrait
        displayHeightRatio = 1;
        keyboardHeightRatio = 3;

        maxWidth = 1000;
        minWidth = min(600, screenWidth);
        maxHeight = screenHeight;
        minHeight = min(600, screenHeight);
      }
    }
   
    final calculatorBackgroundColor = Theme.of(context).extension<CalculatorAppTheme>()!.calculatorBackgroundColor;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            minWidth: minWidth,
            maxHeight: maxHeight,
            minHeight: minHeight,
          ),
          child: Container(
            decoration: BoxDecoration(color: calculatorBackgroundColor),

            child: Column(
              children: [
                // display
                Expanded(
                  flex: displayHeightRatio,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Display(
                      smallText: logic.smallText,
                      largeText: logic.largeText,
                      hasMemory: _showMemoryIndicator,
                      alert: _keyboardError,
                    ),
                  ),
                ),

                // keyboard
                Expanded(
                  flex: keyboardHeightRatio,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Keyboard(onButtonPressed: onKeyboardButtonPressed),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
