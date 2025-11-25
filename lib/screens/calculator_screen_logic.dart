import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/constants/button_labels.dart';
import 'package:flutter_calculator/screens/calculator_screen.dart';
import 'package:flutter_calculator/utils/expression/barrel_file.dart';
import 'package:flutter_calculator/utils/input_extensions.dart';
import 'package:flutter_calculator/utils/number_extensions.dart';


class CalculatorScreenLogic {
  final State<CalculatorScreen> state;

  // state-variabler
  String _result = '0';       // resultat av beräkning
  String _input = '';         // uttryck 
  String _smallText = '';     // liten text i display
  String _largeText = '';     // stor text i display
  bool _isShowingResult = false; // om displayen visar resultat (annars håller användaren på att skriva uttryck)
  bool _isValid = true;       // om senast tryckta knapp accepterades
  String _errorMessage = '';  // felmeddleande i samband med knapptryckning <---- används inte
  Decimal? _memoryValue;       // det värde som lagras i minnet
  bool? _memoryValueChanged;  // om värdet i minnet ändrades när knapp trycktes

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
      case ButtonLabels.memoryAdd:
      case ButtonLabels.memorySubtract:
      case ButtonLabels.memoryRestore:
      case ButtonLabels.memoryClear:
        _memoryButtonClicked(buttonText);
        break;
      case ButtonLabels.clear:
        _clearButtonClicked();
        break;
      case ButtonLabels.delete:
        _deleteButtonClicked();
        break;
      case ButtonLabels.compute:
        _computeButtonClicked();
        break;
      default:
        _numericOrOperatorButtonClicked(buttonText);

        // hantera hur tecken ska läggas till i inmatningsfältet
        if (_isValid) {
          if (_input == '0' && !buttonText.isDecimalPoint()) {         
            _input = buttonText;
          } else if (_input.isEmpty && buttonText.isDecimalPoint()) {
            _input = '0${ButtonLabels.decimalPoint}';
          } else {
            _input += buttonText;
          }
        }
        break;
    }

    // uppdatera displaytexter
    _smallText = _isShowingResult ? _input : '';  // om resultat visas, skriv uttryck med liten text
    _largeText = _isShowingResult ? _result : _input;
  }

  


  void _memoryButtonClicked(memoryButtonText) {
    switch (memoryButtonText) {
      case ButtonLabels.memoryAdd:
        if (_largeText.isEmpty || _largeText.isNumber()) {
          _memoryValue = (_memoryValue ?? Decimal.zero) + (_largeText.toDecimal() ?? Decimal.zero);
          _memoryValueChanged = true;
        } else {
          _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }
        break;

      case ButtonLabels.memorySubtract:
        if (_largeText.isEmpty || _largeText.isNumber()) {
          _memoryValue = (_memoryValue ?? Decimal.zero) - (_largeText.toDecimal() ?? Decimal.zero);
          _memoryValueChanged = true;
        } else {
          _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }
        break;

      case ButtonLabels.memoryRestore:
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

      case ButtonLabels.memoryClear:
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
      keyboardButtonPressed(ButtonLabels.clear);
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

  void _numericOrOperatorButtonClicked(String buttonText) {
    // ... när man visar resultat av beräkning
    if (_isShowingResult) {
      if (buttonText.isDigit()) {
        _input = '';
        _isShowingResult = false;
      } else if (buttonText.isOperator() || buttonText.isLeftParenthesis()) {
        _input = _result;
        _isShowingResult = false;
      } else if (buttonText.isRightParenthesis()) {
        _input = '($_input';
        _isShowingResult = false;
      } else if (buttonText.isDecimalPoint()) {
        bool hasDecimalPoint = false;
        for (int i = 0; i < _result.length && !hasDecimalPoint; i++) {        
          hasDecimalPoint = _result[i].isDecimalPoint();
        }
        if (hasDecimalPoint) {
          _isValid = false;
          _errorMessage = "Två decimaltecken i samma tal.";
        } else {
          _input = _result;
          _isShowingResult = false;
        }
      }
    }

    // ... när man håller på att skriva uttryck
    else {   
      final (valid, error) = _tryNextChar(_input, buttonText);
      _isValid = valid;
      _errorMessage = error;
      if (_isValid) {
        _isShowingResult = false;
      }
    }
  }


  String _getExpressionResult(String expression) {
    final result = calculateExpression(expression);
    String resultAsString = _formatResult(result.toString());
    return resultAsString;
  }

  String _formatResult(String resultAsString) {
    // todo om en massa 0000000000 i rad? tecken på att dator inte kunna beräkna korrekt.
    // maximalt antal tecken?
    

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

    // returnera sträng med valt decimaltecken
    return resultAsString.replaceAll('.', ButtonLabels.decimalPoint);
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
      // tillåt först i uttryck, efter siffror och efter parenteser
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
      // tillåt efter siffror och efter högerparentes
      if (prev.isEmpty) {
        isValid = false;
      } 
      else if (prev == '0' && input.length == 1) {
        isValid = false;  // om det står 0 i inmatningsfältet, tillåt inte operator
      }
      else if (!prev.isDigit() && !prev.isRightParenthesis()) {
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