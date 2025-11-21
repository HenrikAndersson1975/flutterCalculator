import 'package:flutter/material.dart';
import 'package:flutter_calculator/theme/calculator_app_theme.dart';
import 'package:flutter_calculator/theme/extensions/calculator_display_theme.dart';

class Display extends StatelessWidget {
  final String smallText;
  final String largeText;
  final bool hasMemory;
  final bool alert;

  const Display({
    super.key,
    required this.smallText,
    required this.largeText,
    required this.hasMemory,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {

    CalculatorDisplayTheme theme = Theme.of(context).extension<CalculatorAppTheme>()!.display;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
       
        double szFontInput = constraints.maxHeight * 0.27;
        double szFontExpression = szFontInput * 3/4; 
        double szFontMemory = szFontInput/5;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: alert ? theme.displayAlertColor : theme.displayColor,
            border: Border.all(color: alert ? theme.borderAlertColor : theme.borderColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: szFontMemory + 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasMemory ? 'M' : ' ',
                      style: TextStyle(
                        color: theme.memoryIndicatorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: szFontMemory,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                      // liten text för uttryck som beräknats                   
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          smallText,
                          style: TextStyle( 
                            color: theme.smallTextColor,
                            fontSize: szFontExpression,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),

                    const SizedBox(height: 8),

                    // stor text för att visa inmatning eller resultat
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        largeText.isEmpty ? '0' : largeText,
                        style: TextStyle(
                          color: theme.largeTextColor,
                          fontSize: szFontInput,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}