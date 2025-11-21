extension InputCharExtension on String
{

  bool isDigit() {
    String char = this;
    return char != '' && (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57);
  }

  bool isDecimalPoint() {
     String char = this;
    return char == ',' || char == '.';
  }

  bool isOperator() {
    String char = this;
    return char.isAddOperator() ||
        char.isSubtractOperator() ||
        char.isMultiplyOperator() ||
        char.isDivideOperator();
  }

  bool isAddOperator() {
     String char = this;
    return char == '+';
  }

  bool isSubtractOperator() {
     String char = this;
    return char == '-';
  }

  bool isMultiplyOperator() {
    String char = this;
    return char == '*';
  }

  bool isDivideOperator() {
     String char = this;
    return char == '/';
  }

  bool isParenthesis() {
    String char = this;
    return char.isLeftParenthesis() || char.isRightParenthesis();
  }

  bool isLeftParenthesis() {
    String char = this;
    return char == '(';
  }

  bool isRightParenthesis() {
    String char=this;
    return char == ')';
  }
}