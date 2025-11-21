import 'package:flutter/material.dart';

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
    Color borderColor = alert ? Colors.red : Colors.black;
    Color displayColor = alert ? Colors.red : Colors.white;

    
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
       
        double szFontInput = constraints.maxHeight * 0.27;
        double szFontExpression = szFontInput * 3/4; 
        double szFontMemory = szFontInput/5;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: displayColor,
            border: Border.all(color: borderColor, width: 1),
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
                        color: Colors.black,
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