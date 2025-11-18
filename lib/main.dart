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
        // Definiera ditt eget tema här
        //primarySwatch: Colors.blue, // Primär färg för appen
        
        textTheme: TextTheme(
             labelLarge: TextStyle(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
             labelMedium: TextStyle(fontSize: 16, color: Colors.black), 
               
        ),

      /*  elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
 
            foregroundColor: Colors.black,
            backgroundColor: Colors.green,
            disabledForegroundColor: const Colors.grey,
            disabledBackgroundColor: Colors.green,

            

          ),
        ),
*/

       /* buttonTheme: ButtonThemeData(



          buttonColor: Colors.blue, // Bakgrundsfärg för knappar
          disabledColor: Colors.grey,


          textTheme: ButtonTextTheme.primary, // Textfärg för knappar
        ),*/
        scaffoldBackgroundColor: const Color.fromARGB(255, 112, 109, 109) // Bakgrundsfärg för hela appen
      ),

      

     

      home: SafeArea(child: const CalculatorScreen(title: 'Flutter-kalkylator')),
    );
  }
}


