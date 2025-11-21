import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets/button.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onButtonPressed;
  final bool alert;

  const Keyboard({
    super.key,
    required this.onButtonPressed,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      Button(
        label: 'M+',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.memory,
      ),
      Button(
        label: 'M-',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.memory,
      ),
      Button(
        label: 'MR',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.memory,
      ),
      Button(
        label: 'MC',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.memory,
      ),

      Button(
        label: '7',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '8',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '9',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '/',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),

      Button(
        label: '4',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '5',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '6',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '*',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),

      Button(
        label: '1',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '2',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '3',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: '-',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),

      Button(
        label: '0',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: ',',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.number,
      ),
      Button(
        label: 'DEL',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.other,
      ),
      Button(
        label: '+',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),

      Button(
        label: '(',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),
      Button(
        label: ')',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.operator,
      ),
      Button(
        label: 'C',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.other,
      ),
      Button(
        label: '=',
        onPressed: onButtonPressed,
        buttonFunction: ButtonFunction.other,
      ),
    ];

    List<int> landscapeLayout = [0, 4, 5, 6, 20, 21,1,8,9,10,11,7,2,12,13,14,19,15,3,16,17,18,22,23];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        bool isLandscape = constraints.maxWidth > constraints.maxHeight;

        int columnsCount = isLandscape ? 6 : 4;  
        int rowsCount = (buttons.length / columnsCount).ceil();

        double columnSpacing = 6;
        double rowSpacing = 6;  

        double buttonWidth = (constraints.maxWidth - (columnsCount - 1) * columnSpacing)/ columnsCount;
        double buttonHeight = (constraints.maxHeight - (rowsCount - 1) * rowSpacing) / rowsCount;
       
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnsCount,
            childAspectRatio: buttonWidth / buttonHeight,
            crossAxisSpacing: columnSpacing, 
            mainAxisSpacing: rowSpacing, 
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            int adaptedIndex = isLandscape ? landscapeLayout[index] : index;
            return buttons[adaptedIndex];
          },
        );
      },
    );
  }
}
