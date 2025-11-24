import 'package:flutter_calculator/constants/button_labels.dart';

extension InputExtension on String
{
  bool isDigit() {
    return this != '' && (codeUnitAt(0) >= 48 && codeUnitAt(0) <= 57);
  }

  bool isDecimalPoint() {
    return this == ButtonLabels.decimalPoint || this == '.';
  }

  bool isOperator() {
    return isAddOperator() ||
        isSubtractOperator() ||
        isMultiplyOperator() ||
        isDivideOperator();
  }

  bool isAddOperator() {
    return this == ButtonLabels.operatorAdd;
  }

  bool isSubtractOperator() {
    return this == ButtonLabels.operatorSubtract;
  }

  bool isMultiplyOperator() {
    return this == ButtonLabels.operatorMultiply;
  }

  bool isDivideOperator() {
    return this == ButtonLabels.operatorDivide;
  }

  bool isParenthesis() {
    return isLeftParenthesis() || isRightParenthesis();
  }

  bool isLeftParenthesis() {
    return this == ButtonLabels.parenthesisLeft;
  }

  bool isRightParenthesis() {
    return this == ButtonLabels.parenthesisRight;
  }


  bool isMemoryAdd() {
    return this == ButtonLabels.memoryAdd;
  }
  bool isMemorySubtract() {
    return this == ButtonLabels.memorySubtract;
  }
  bool isMemoryRestore() {
    return this == ButtonLabels.memoryRestore;
  }
  bool isMemoryClear() {
    return this == ButtonLabels.memoryClear;
  }
  bool isMemory() {
    return isMemoryAdd() || isMemorySubtract() || isMemoryRestore() || isMemoryClear();
  }
}