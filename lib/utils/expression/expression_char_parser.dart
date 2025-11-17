bool isDigit(String char) {
  return char != '' && (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57);
}

bool isDecimalPoint(String char) {
  return char == ',' || char == '.';
}

bool isOperator(String char) {
  return isAddOperator(char) ||
      isSubtractOperator(char) ||
      isMultiplyOperator(char) ||
      isDivideOperator(char);
}

bool isAddOperator(String char) {
  return char == '+';
}

bool isSubtractOperator(String char) {
  return char == '-';
}

bool isMultiplyOperator(String char) {
  return char == '*';
}

bool isDivideOperator(String char) {
  return char == '/';
}

bool isParenthesis(String char) {
  return isLeftParenthesis(char) || isRightParenthesis(char);
}

bool isLeftParenthesis(String char) {
  return char == '(';
}

bool isRightParenthesis(String char) {
  return char == ')';
}
