import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets/button.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onButtonPressed;
  final bool alert;

  const Keyboard({super.key, required this.onButtonPressed, this.alert = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         Row(
          children: [
            Button(label: 'M+', onPressed: onButtonPressed, buttonFunction: ButtonFunction.memory,),
            Button(label: 'M-', onPressed: onButtonPressed, buttonFunction: ButtonFunction.memory,),
            Button(label: 'MR', onPressed: onButtonPressed, buttonFunction: ButtonFunction.memory,),
            Button(label: 'MC', onPressed: onButtonPressed, buttonFunction: ButtonFunction.memory,),
          ],
        ),
        Row(
          children: [
            Button(label: '7', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '8', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '9', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '/', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),
          ],
        ),
        Row(
          children: [
            Button(label: '4', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '5', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '6', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '*', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),
          ],
        ),
        Row(
          children: [
             Button(label: '1', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '2', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '3', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: '-', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),        
          ],
        ),
        Row(
          children: [
             Button(label: '0', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: ',', onPressed: onButtonPressed, buttonFunction: ButtonFunction.number,),
            Button(label: 'DEL', onPressed: onButtonPressed, buttonFunction: ButtonFunction.other,),
            Button(label: '+', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),     
          ],
        ),
        Row(
          children: [
            Button(label: '(', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),
            Button(label: ')', onPressed: onButtonPressed, buttonFunction: ButtonFunction.operator,),
            Button(label: 'C', onPressed: onButtonPressed, buttonFunction: ButtonFunction.other,),
            Button(label: '=', onPressed: onButtonPressed, buttonFunction: ButtonFunction.other,),  
          ],
        ),
      ],
    );
  }
}
