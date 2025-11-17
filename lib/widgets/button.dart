
import 'package:flutter/material.dart';

enum ButtonFunction { number, operator, memory, other }

class Button extends StatefulWidget {
  final String label;
  final Function(String) onPressed;
  final ButtonFunction buttonFunction;
  final bool isDisabled;

  const Button({super.key, required this.label, required this.onPressed, required this.buttonFunction, this.isDisabled = false});

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
  

   final Color bgColor =  const Color.fromARGB(255, 177, 169, 169);
    


  final Color textColor = widget.isDisabled 
      ? const Color.fromARGB(255, 131, 131, 131) 
      : switch (widget.buttonFunction) {
          ButtonFunction.operator   =>  const Color.fromARGB(255, 31, 29, 29),
          ButtonFunction.memory => const Color.fromARGB(255, 0, 121, 41), 
          ButtonFunction.number   => const Color.fromARGB(255, 20, 17, 230), 
          ButtonFunction.other    => const Color.fromARGB(255, 221, 69, 69),
        };

  

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : _onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: 
                  
                   [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
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
      ),
    ),
  );
}

}


