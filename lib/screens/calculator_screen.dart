import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen_logic.dart';
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

  Timer? _errorTimer;
  bool _keyboardError=false;

  @override
  void initState() {
    super.initState();
    logic = CalculatorScreenLogic(this);
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  // 
  void onKeyboardButtonPressed(String buttonText) {
    setState(() {
      logic.keyboardButtonPressed(buttonText);    
      if (!logic.isValid) {
        _triggerKeyboardError();
      }
    });
  }

  void _triggerKeyboardError() {
    _keyboardError = true;
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _keyboardError = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
       body: SafeArea(
         child: Column(
            children: [
          
              // fast höjd på display
              SizedBox(
                height: 100, 
                child: Display(
                  smallText: logic.smallText,
                  largeText: logic.largeText,
                  hasMemory: logic.hasMemory,
                  alert: _keyboardError,
                ),
              ),
            
              // keyboard tar upp resten av höjden
              Expanded(
                child: Keyboard(onButtonPressed: onKeyboardButtonPressed),
              ),
            ],
          ),
       ),
    );
  }
}

