import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen.dart';
import 'package:flutter_calculator/utils/expression/barrel_file.dart';
import 'package:flutter_calculator/utils/extensions.dart';

class CalculatorScreenLogic {
  final State<CalculatorScreen> state;

  // state-variabler
  String _result = '0';
  String _input = '';
  String _smallText = '';
  String _largeText = '';
  bool _isShowingResult = false;
  bool _isValid = true;
  String _errorMessage = '';
  double? _memoryValue;
  bool? _memoryValueChanged;

  // värden som ui använder
  String get smallText => _smallText;
  String get largeText => _largeText;
  bool get isValid => _isValid;
  String get errorMessage => _errorMessage;
  bool get hasMemory => _memoryValue != null;
  bool get memoryValueChanged => _memoryValueChanged ?? false;

  CalculatorScreenLogic(this.state);

  void keyboardButtonPressed(String buttonText) {
    _isValid = true;
    _errorMessage = '';
    _memoryValueChanged = false;

    switch (buttonText) {
      case 'M+':
      case 'M-':
      case 'MR':
      case 'MC':
        _memoryButtonClicked(buttonText);
        break;
      case 'C':
        _clearButtonClicked();
        break;
      case 'DEL':
        _deleteButtonClicked();
        break;
      case '=':
        _computeButtonClicked();
        break;
      default:
        if (_isShowingResult && buttonText.isDigit()) {
          _input = '';
          _isShowingResult = false;
        } 
        else if (_isShowingResult && (buttonText.isOperator() || buttonText.isLeftParenthesis() || buttonText.isDecimalPoint())) {
          _input = _result;
          _isShowingResult = false;
        } 
        else if (_isShowingResult && buttonText.isRightParenthesis()) {
          _input = '($_input';
          _isShowingResult = false;
        } else {
          final (valid, error) = _tryNextChar(
            _input,
            buttonText,
          );
          _isValid = valid;
          _errorMessage = error;
          if (_isValid) { 
            _isShowingResult = false;
          }
        }

        //
        if (_isValid) {
          if (_input == '0' && !buttonText.isDecimalPoint()) {
            _input = buttonText;
          } else if (_input.isEmpty && buttonText.isDecimalPoint()) {
            _input = '0,';
          } else {
            _input += buttonText;
          }
        }
        break;
    }

    // uppdatera displaytexter
    _smallText = _isShowingResult ? _input : '';
    _largeText = _isShowingResult ? _result : _input;
  }

  void _memoryButtonClicked(memoryButtonText) {
    switch (memoryButtonText) {
      case 'M+':
        if (_largeText.isEmpty || _largeText.isNumber()) {
          _memoryValue = (_memoryValue ?? 0) + (_largeText.toDouble() ?? 0);
          _memoryValueChanged = true;
        } else {
          _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }
        break;

      case 'M-':
        if (_largeText.isEmpty || _largeText.isNumber()) {
          _memoryValue = (_memoryValue ?? 0) - (_largeText.toDouble() ?? 0);
          _memoryValueChanged = true;
        } else {
          _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }
        break;

      case 'MR':
        if (_memoryValue != null) {
          if (_isShowingResult || _largeText == "0") {
            _isValid = true;
            _input = _formatResult(_memoryValue.toString());
          } else {
            String lastChar = _largeText[_largeText.length - 1];
            if (lastChar.isOperator() || lastChar.isLeftParenthesis()) {
              _input = _largeText + _formatResult(_memoryValue.toString());
            } else {
              _input = _formatResult(_memoryValue.toString());
            }
          }
          _isShowingResult = false;
        } else {
          _isValid = false;
        }
        break;

      case 'MC':
        _memoryValue = null;
        break;
    }
  }

  void _clearButtonClicked() {
    _input = '0';
    _result = '';
    _isShowingResult = false;
  }

  void _deleteButtonClicked() {
    /*if(_isShowingResult) {
      _input = _result;         
    }*/
    _input = _input.isNotEmpty ? _input.substring(0, _input.length - 1) : '';
    if (_input.isEmpty) {
      keyboardButtonPressed('C');
    } else {
      _result = '';
      _isShowingResult = false;
    }
  }

  void _computeButtonClicked() {
    if (_isShowingResult) {
      // TODO: Upprepa senaste operation?
      _isValid = false;
      return;
    } else {
      final (evaluate, error) = _isValidExpression(_input);
      _errorMessage = error;
      _isValid = error.isEmpty;

      if (evaluate) {
        _isShowingResult = true;
        try {
          _result = _getExpressionResult(_input);
        } catch (e) {
          _result = e.toString();
        }
      }
    }
  }

  String _getExpressionResult(String expression) {
    final result = calculateExpression(expression);
    String resultAsString = _formatResult(result.toString());
    return resultAsString;
  }

  String _formatResult(String resultAsString) {
    // todo om en massa 0000000000
    // maximalt antal tecken
    //

    // om är ett decimaltal, ta bort alla avslutande nollor
    if (resultAsString.contains('.')) {
      while (resultAsString.isNotEmpty && resultAsString.endsWith('0')) {
        resultAsString = resultAsString.substring(0, resultAsString.length - 1);
      }

      // om alla tecken efter decimaltecknet var nollor, ta bort decimaltecknet också
      if (resultAsString.endsWith('.')) {
        resultAsString = resultAsString.substring(0, resultAsString.length - 1);
      }
    }

    // returnera sträng med , som decimaltecken
    return resultAsString.replaceAll('.', ',');
  }

  // kontrollerar om uttryck är giltigt
  // uttrycket har klarat varje steg i _tryNextChar, så mycket kontroll kan utelämnas
  (bool, String) _isValidExpression(String expression) {
    bool isValid = false;
    String errorMessage = '';
    String lastChar = expression.isNotEmpty
        ? expression[expression.length - 1]
        : '';

    if (lastChar.isDigit() || lastChar.isRightParenthesis()) {
      int lefts = 0, rights = 0;
      for (var char in expression.split('')) {
        if (char.isLeftParenthesis()) {
          lefts++;
        } else if (char.isRightParenthesis()) {
          rights++;
        }
      }
      if (lefts == rights) {
        isValid = true;
      } else {
        errorMessage = "Olika antal vänster- och högerparenteser.";
      }
    } else {
      errorMessage = "Uttryck måste sluta med siffra eller högerparentes.";
    }
    return (isValid, errorMessage);
  }

  // kontrollerar om inmatning {inputChar} passar när man har {input} i inmatningsfältet
  (bool, String) _tryNextChar(String input, String inputChar) {
    bool isValid = true;
    String errorMessage = '';
    String prev = input.isNotEmpty ? input[input.length - 1] : '';

    // decimaltecken
    if (inputChar.isDecimalPoint()) {
      if (prev.isNotEmpty && prev.isDigit()) {
        int pos = input.length - 2;
        while (pos >= 0) {
          String c = input[pos];
          if (c.isDecimalPoint()) {
            isValid = false;
            errorMessage = "Två decimaltecken i samma tal.";
            break;
          } else if (c.isOperator() || c.isParenthesis()) {
            // avbryt sökning efter decimaltecken
            break;
          }
          pos--;
        }
      } else if (prev.isNotEmpty) {
        isValid = false;
        errorMessage = "Kan bara ha decimaltecken efter siffra.";
      }
    } 
    // minustecken
    else if (inputChar.isSubtractOperator()) {
      // tillåt efter siffror och efter parenteser
      isValid =
          (prev.isEmpty ||
          prev.isDigit() ||
          prev.isRightParenthesis() ||
          prev.isLeftParenthesis());
      if (!isValid) {
        errorMessage = "Hantera minustecken bättre!";
      }
    } 
    // övriga operatorer
    else if (inputChar.isOperator()) {
      if (prev.isEmpty) {
        isValid = false;
      } else if (!prev.isDigit() && !prev.isRightParenthesis()) {
        isValid = false;
      }
      if (!isValid) {
        errorMessage = "Hur hanterar du operatorer?";
      }
    } 
    // vänsterparentes
    else if (inputChar.isLeftParenthesis()) {
      if (prev.isDecimalPoint()) {
        isValid = false;
        errorMessage = "Vänsterparentes kan inte komma efter decimaltecken.";
      }
    } 
    // högerparentes
    else if (inputChar.isRightParenthesis()) {
      if (!prev.isDigit() && !prev.isRightParenthesis()) {
        isValid = false;
        errorMessage =
            "Högerparentes kan bara komma efter siffra eller högerparentes.";
      } else {
        int lefts = 0, rights = 0;
        for (var c in input.split('')) {
          if (c.isLeftParenthesis()) {
            lefts++;
          } else if (c.isRightParenthesis()) {
            rights++;
          }
        }
        if (rights >= lefts) {
          isValid = false;
          errorMessage = "För många högerparenteser.";
        }
      }
    }
    // siffra
    else if (inputChar.isDigit()) {
      isValid = prev.isEmpty || !prev.isRightParenthesis();
    }

    return (isValid, errorMessage);
  }
}