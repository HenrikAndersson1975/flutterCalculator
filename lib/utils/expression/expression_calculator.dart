import 'package:flutter_calculator/constants/button_labels.dart';
import 'package:flutter_calculator/utils/expression/barrel_file.dart';
import 'package:flutter_calculator/utils/input_extensions.dart';

//
// beräknar resultat (tal) av uttrycket
//
double calculateExpression(String expression) {
  final tokens = _tokenizeExpression(expression);
  final rpn = _toReversePolishNotation(tokens);
  double result = _evaluateReversePolishNotation(rpn);
  return result;
}

List<Token> _tokenizeExpression(String expression) {

  //
  expression = _expandScientificNotation(expression);
  expression = expression.replaceAll(' ', '').replaceAll(',', '.');
  expression = _handleSubtractOperators(expression);

  final tokens = <Token>[];
  final chars = expression.split('');
  int i = 0;

  while (i < chars.length) {
    final char = chars[i];

    // hantera tal
    if (chars[i].isDigit()) {     
      String num = '';
      while (i < chars.length &&
          (chars[i].isDigit() || chars[i].isDecimalPoint())) {
        num += chars[i];
        i++;
      }
      double number = double.parse(num);
      tokens.add(Token(TokenType.number, number));
      continue;
    }
   
    // hantera operatorer
    if (char.isAddOperator()) { tokens.add(Token(TokenType.add)); }
    else if (char.isSubtractOperator()) { tokens.add(Token(TokenType.subtract));}
    else if (char.isMultiplyOperator())  { tokens.add(Token(TokenType.multiply));}
    else if (char.isDivideOperator()) { tokens.add(Token(TokenType.divide));}

    // hantera parenteser
    else if (char.isLeftParenthesis()) {
        String previousChar = i>0 ? chars[i-1] : '';
        // om föregående är ) eller siffra lägg in en multiply
        if (previousChar.isRightParenthesis() || previousChar.isDigit()) {
          tokens.add(Token(TokenType.multiply));
        }
        tokens.add(Token(TokenType.leftParenthesis));
    }
    else if (char.isRightParenthesis()) {
      tokens.add(Token(TokenType.rightParenthesis));
    }

    else {
      throw Exception('Ogiltigt tecken: $char');
    }

    i++;
  }

  return tokens;
}

String _handleSubtractOperators(String expression) {

  String subtractOperatorReplacement = "${ButtonLabels.parenthesisLeft}0${ButtonLabels.operatorSubtract}1${ButtonLabels.parenthesisRight}${ButtonLabels.operatorMultiply}"; // '(0-1)*'

  // om minustecken efter vänsterparentes
  expression = expression.replaceAll('${ButtonLabels.parenthesisLeft}${ButtonLabels.operatorSubtract}', '($subtractOperatorReplacement');  // '(-' ==> '((0-1)*'

  // om inleder med minustecken  
  if (expression.isNotEmpty && expression[0].isSubtractOperator()) { expression = '$subtractOperatorReplacement${expression.substring(1)}'; }  // '-' ==> '(0-1)*'

  return expression;
}


List<Token> _toReversePolishNotation(List<Token> tokens) {
  final output = <Token>[];
  final operators = <Token>[];

  int precedence(TokenType type) {
    switch (type) {
      case TokenType.add:
      case TokenType.subtract:
        return 1;
      case TokenType.multiply:
      case TokenType.divide:
        return 2;
      default:
        return 0;
    }
  }

  bool isLeftAssociative(TokenType type) {
    return type == TokenType.add ||
        type == TokenType.subtract ||
        type == TokenType.multiply ||
        type == TokenType.divide;
  }

  for (final token in tokens) {
    if (token.type == TokenType.number) {
      output.add(token);
    } else if (token.type == TokenType.leftParenthesis) {
      operators.add(token);
    } else if (token.type == TokenType.rightParenthesis) {
      while (operators.isNotEmpty &&
          operators.last.type != TokenType.leftParenthesis) {
        output.add(operators.removeLast());
      }
      if (operators.isNotEmpty && operators.last.type == TokenType.leftParenthesis) {
        operators.removeLast(); // ta bort (
      } else {
        throw Exception('Felaktiga parenteser');
      }
    } else {
      // operator
      while (operators.isNotEmpty &&
          operators.last.type != TokenType.leftParenthesis &&
          (precedence(operators.last.type) > precedence(token.type) ||
              (precedence(operators.last.type) == precedence(token.type) &&
                  isLeftAssociative(token.type)))) {
        output.add(operators.removeLast());
      }
      operators.add(token);
    }
  }

  while (operators.isNotEmpty) {
    if (operators.last.type == TokenType.leftParenthesis) {
      throw Exception('Felaktiga parenteser');
    }
    output.add(operators.removeLast());
  }

  return output;
}

double _evaluateReversePolishNotation(List<Token> rpn) {
  final stack = <double>[];

  for (final token in rpn) {
    if (token.type == TokenType.number) {
      stack.add(token.value!);
    } else {
      if (stack.length < 2) throw Exception('Ogiltigt uttryck');

      final b = stack.removeLast();
      final a = stack.removeLast();

      double mathsOperationResult;
      {
      switch (token.type) {
        case TokenType.add:
          mathsOperationResult=operationAdd(a, b);
          break;
        case TokenType.subtract:         
          mathsOperationResult=operationSubtract(a, b);
          break;
        case TokenType.multiply:         
          mathsOperationResult=operationMultiply(a, b);
          break;
        case TokenType.divide:               
          mathsOperationResult=operationDivide(a, b);

          break;
        default:
          throw Exception('Okänd operator');
      }
      }
      stack.add(mathsOperationResult);
    }
  }

  if (stack.length != 1) throw Exception('Ogiltigt uttryck');
  return stack.first;
}

// ta bort e+??? och e-??? och ersätt med multiplikation
String _expandScientificNotation(String expression) {
  return expression.replaceAllMapped(
    RegExp(r'(\d*\.?\d+)[eE]([+-]?\d+)'),
    (match) {
      final String mantissa = match.group(1)!;
      final String exponentStr = match.group(2)!;
      final int exponent = int.parse(exponentStr);

      // Räkna ut 10^exponent som ett vanligt tal
      final String powerOfTen = exponent >= 0
          ? '1' + '0' * exponent                  // t.ex. e+5 → 100000
          : '0.' + '0' * (-exponent - 1) + '1';   // t.ex. e-3 → 0.001

      // Om det är 1 eller 0.XXXX så skippa onödig etta
      if (mantissa == '1' && exponent >= 0) {
        return powerOfTen;  // 1e+8 → 100000000 (ingen *1)
      }
      if (mantissa == '1' && exponent < 0) {
        return powerOfTen;  // 1e-5 → 0.00001
      }

      return '$mantissa*$powerOfTen';
    },
  );
}