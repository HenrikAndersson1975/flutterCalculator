import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uträknare',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
                     
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      
        scaffoldBackgroundColor: const Color.fromARGB(255, 212, 219, 211) // Bakgrundsfärg för hela appen

        
      ),

      

     

      home: SafeArea(child: const CalculatorScreen(title: 'Flutter-kalkylator')),
    );
  }
}


