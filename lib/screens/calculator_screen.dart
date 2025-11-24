import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen_logic.dart';
import 'package:flutter_calculator/theme/calculator_screen_theme.dart';
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
      // skicka knapp till logikhantering
      logic.keyboardButtonPressed(buttonText);

      // om minnesvärde finns
      _showMemoryIndicator = logic.hasMemory;

      // indikera att knapptryckning inte kunde hanteras
      if (!logic.isValid) {
        _triggerKeyboardErrorIndication();
      }
      // indikera att minnesvärde har ändrats
      else if (logic.hasMemory && logic.memoryValueChanged) {
        _triggerMemoryUpdatedIndication();
      }
    });
  }

  // visar felindikering vid ogiltig knapptryckning
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

  // visar minnesindikering vid ändrat minnesvärde
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

    // höjdfördelning mellan display och keyboard
    int displayHeightRatio;
    int keyboardHeightRatio;
    (displayHeightRatio, keyboardHeightRatio) = _getCalculatorPartsHeights(
      screenWidth,
      screenHeight,
    );

    // storleksbegränsningar för kalkylatorn
    BoxConstraints calculatorSizeConstraints = _getCalculatorSizeConstraints(
      screenWidth,
      screenHeight,
    );

    final calculatorBackgroundColor = Theme.of(
      context,
    ).extension<CalculatorScreenTheme>()!.backgroundColor;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: calculatorSizeConstraints,
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

  (int, int) _getCalculatorPartsHeights(
    double screenWidth,
    double screenHeight,
  ) {
    bool isLandscape = screenWidth > screenHeight;
    int displayHeightRatio = isLandscape ? 2 : 1;
    int keyboardHeightRatio = 3;
    return (displayHeightRatio, keyboardHeightRatio);
  }

  BoxConstraints _getCalculatorSizeConstraints(
    double screenWidth,
    double screenHeight,
  ) {
    bool isLandscape = screenWidth > screenHeight;
    double maxWidth, minWidth;
    double maxHeight, minHeight;
    {
      if (isLandscape) {
        maxWidth = min(1000, screenWidth);
        minWidth = min(500, screenWidth);
        maxHeight = min(800, screenHeight);
        minHeight = min(500, screenHeight);
      } else {
        maxWidth = min(1000, screenWidth);
        minWidth = min(600, screenWidth);
        maxHeight = screenHeight;
        minHeight = min(600, screenHeight);
      }
    }

    return BoxConstraints(
      maxWidth: maxWidth,
      minWidth: minWidth,
      maxHeight: maxHeight,
      minHeight: minHeight,
    );
  }
}
