import 'package:flutter_calculator/utils/expression/barrel_file.dart';


extension NumberExtension on String
{
  
  bool isNumber() {
    String text = this;
    bool isNumber = text.isNotEmpty;
    for (int i=0; i<text.length && isNumber; i++) {
      String char = text[i];
      isNumber =  (char.isSubtractOperator()&&i==0 && text.length>1) || char.isDigit() || (char.isDecimalPoint() && i!=text.length-1);
    }
    return isNumber;
  }

  double? toDouble() {
    String text = this;
    double? value;
    try {
      value = double.parse(text.replaceAll(',', '.'));
    }
    catch (e) {
      value = null;
    }
    return value;
  }
}

