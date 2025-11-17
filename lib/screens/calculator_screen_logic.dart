import 'package:flutter/material.dart';
import 'package:flutter_calculator/screens/calculator_screen.dart';
import 'package:flutter_calculator/utils/expression/expression_calculator.dart';
import 'package:flutter_calculator/utils/expression/expression_char_parser.dart';

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

  // värden som ui använder
  String get smallText => _smallText;
  String get largeText => _largeText;
  bool get isValid => _isValid;
  String get errorMessage => _errorMessage;
  bool get hasMemory => _memoryValue != null;

  CalculatorScreenLogic(this.state);

  void keyboardButtonPressed(String buttonText) {

    _isValid = true;
    _errorMessage = '';

    switch (buttonText) {

      // MINNESKNAPPAR
      case 'M+':
        // fungerar om tal i inmatningsfält
        if (_largeText.isEmpty || _isNumber(_largeText)) {                
          _memoryValue = (_memoryValue ?? 0) + double.parse(_largeText.replaceAll(',', ','));
        }
        else {
           _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }    
        break;
        
      case 'M-':
        // fungerar om tal i inmatningsfält
        if (_largeText.isEmpty || _isNumber(_largeText)) {
         
          _memoryValue = (_memoryValue ?? 0) - double.parse(_largeText.replaceAll(',', ','));         
        }
        else {
          _isValid = false;
          _errorMessage = "Inte ett tal i inmatningsfältet.";
        }
        break;  
      
      case 'MR':
        // lägg innehållet i minnet till display
        if (_memoryValue != null) {    

          if (_isShowingResult || _largeText == "0") {
            _isValid = true;               
            _input =  _formatResult(_memoryValue.toString());
          }
          else {
           
            // om föregående är operator eller vänsterparentes 
            String lastChar = _largeText[_largeText.length-1];
             
            if (isOperator(lastChar) || isLeftParenthesis(lastChar)) {
              _input = _largeText + _formatResult(_memoryValue.toString());
            }    
            else {
              _input = _formatResult(_memoryValue.toString());
            }
          }

          _isShowingResult = false;  
        }
        else {
          _isValid = false;
        }
        break;
        
      case 'MC':
        // rensa minnet
        _memoryValue = null;
        break;
       
      // CLEAR
      case 'C':
        _input = '0';
        _result = '';
        _isShowingResult = false;
        break;

      // DELETE
      case 'DEL':
        _input = _input.isNotEmpty
            ? _input.substring(0, _input.length - 1)
            : '';
        if (_input.isEmpty) {
          keyboardButtonPressed('C');
        } else {
          _result = '';
          _isShowingResult = false;
        }
        break;

      // BERÄKNA
      case '=':
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
              // logga uttryck och resultat?
            }
            catch(e) {
              _result = e.toString();
            }        
          }
        }
        break;

      // ÖVRIGA KNAPPAR
      default:

        // om i resultat visas i display
        if (_isShowingResult) {
          if (isDigit(buttonText)) {
            _input = '';
            _result = '';
            _isShowingResult = false;
          } else if (isDecimalPoint(buttonText)) {
            if (_input.contains(',')) {
              _input = '0';
            } else {
              _input = _result;
            }
            _result = '';
            _isShowingResult = false;
          } else if (isOperator(buttonText)) {
            if (_result.isNotEmpty) {
              _input = _result;
              _result = '';
              _isShowingResult = false;
            } else {
              _errorMessage = "Kan inte använda operator här.";
              _isValid = false;
            }
          } else if (isLeftParenthesis(buttonText)) {
            _input = _result;
            _result = '';
            _isShowingResult = false;
          } else {
            _isValid = false;
            _errorMessage = "Ogiltig inmatning";
          }
        }

        // om resultat inte visas i display
        // kontrollera om nästa tecken (siffra eller operator) får användas i detta läge
        else {
          final (valid, error) = _tryNextChar(_input, buttonText);
          _isValid = valid;
          _errorMessage = error;
        }


        //
        if (_isValid) {
          if (_input == '0' && !isDecimalPoint(buttonText)) {
            _input = buttonText;
          } else if (_input.isEmpty && isDecimalPoint(buttonText)) {
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

  String _getExpressionResult(String expression) { 
    final result = calculateExpression(expression);
    String resultAsString = _formatResult(result.toString());
    return resultAsString;  
  }

  String _formatResult(String resultAsString) {
    // todo om en massa 0000000000
    // maximalt antal tecken

  
    // 


    if (resultAsString.contains('.')) {
      while (resultAsString.isNotEmpty && resultAsString.endsWith('0')) {
        resultAsString = resultAsString.substring(0, resultAsString.length - 1);
      }
      if (resultAsString.endsWith('.')) {
        resultAsString = resultAsString.substring(0, resultAsString.length - 1);
      }
    }
 
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

    if (isDigit(lastChar) || isRightParenthesis(lastChar)) {
      int lefts = 0, rights = 0;
      for (var char in expression.split('')) {
        if (isLeftParenthesis(char)) {
          lefts++;
        } else if (isRightParenthesis(char)) {
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

  // kontrollerar inmatning {_inputChar} passar när man har {_input} i inmatningsfältet
  (bool, String) _tryNextChar(String input, String inputChar) {
    bool isValid = true;
    String errorMessage = '';
    String prev = input.isNotEmpty ? input[input.length - 1] : '';

    if (isDecimalPoint(inputChar)) {
      if (prev.isNotEmpty && isDigit(prev)) {
        int pos = input.length - 2;
        while (pos >= 0) {
          String c = input[pos];
          if (isDecimalPoint(c)) {
            isValid = false;
            errorMessage = "Två decimaltecken i samma tal.";
            break;
          } else if (isOperator(c) || isParenthesis(c)) {
            // avbryt sökning efter decimaltecken
            break;
          }
          pos--;
        }
      } else if (prev.isNotEmpty) {
        isValid = false;
        errorMessage = "Kan bara ha decimaltecken efter siffra.";
      }
    } else if (isOperator(inputChar)) {
      if (prev.isEmpty && !isSubtractOperator(inputChar)) {
        isValid = false;
      } else if (!isDigit(prev) && !isRightParenthesis(prev)) {
        isValid = false;
      }
      if (!isValid) {
        // men tillåter att uttryck startar med ett minustecken
        errorMessage = "Operator måste komma efter siffra eller högerparentes.";
      }
    } else if (isLeftParenthesis(inputChar)) {
      if (isDecimalPoint(prev)) {
        isValid = false;
        errorMessage = "Vänsterparentes kan inte komma efter decimaltecken.";
      }
    } else if (isRightParenthesis(inputChar)) {
      if (!isDigit(prev) && !isRightParenthesis(prev)) {
        isValid = false;
        errorMessage =
            "Högerparentes kan bara komma efter siffra eller högerparentes.";
      } else {
        int lefts = 0, rights = 0;
        for (var c in input.split('')) {
          if (isLeftParenthesis(c)) {
            lefts++;
          } else if (isRightParenthesis(c)) {
            rights++;
          }
        }
        if (rights >= lefts) {
          isValid = false;
          errorMessage = "För många högerparenteser.";
        }
      }
    }

    return (isValid, errorMessage);
  }

  bool _isNumber(String input) {
    bool isNumber = true;
    for (int i=0; i<input.length && isNumber; i++) {
      String char = input[i];
      isNumber =  (isSubtractOperator(char)&&i==0 && input.length>1) ||  isDigit(char) || (isDecimalPoint(char) && i!=input.length-1);
    }
    return isNumber;
  }
}
