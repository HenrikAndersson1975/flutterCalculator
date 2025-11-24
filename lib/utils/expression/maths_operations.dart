
import 'dart:math';

bool _scalingEnabled = false;

//"3,2(2*3,63+2,23)" men ger 30.368000000000002 utan scaling. Med scaling erhålls rätt resultat.
//  samtidigt finns det andra problem med scaling

double operationAdd(double a, double b) {

  if (_useScaling(a,b)) {
    int factor = max(_getScalingFactor(a),_getScalingFactor(b));
    int ia = _scaleToInteger(a, factor);
    int ib = _scaleToInteger(b, factor);
    return _fromScaledInteger(ia+ib, factor);
  }
  else {
    return a + b;
  }
}

double operationSubtract(double a, double b) {
 
  if (_useScaling(a,b)) {
    int factor = max(_getScalingFactor(a),_getScalingFactor(b));
    int ia = _scaleToInteger(a, factor);
    int ib = _scaleToInteger(b, factor);
    return _fromScaledInteger(ia-ib, factor);
  }
  else {
    return a - b;
  }

}
double operationMultiply(double a, double b) {
 
  if (_useScaling(a,b)) {
    int factorA = _getScalingFactor(a);
    int factorB = _getScalingFactor(b);
    int ia = _scaleToInteger(a, factorA);
    int ib = _scaleToInteger(b, factorB);
    return _fromScaledInteger(ia*ib,(factorA*factorB));
  }
  else {
    return a * b;
  }

}
double operationDivide(double a, double b) {
  if (b == 0) throw Exception('Division med noll');

  if (_useScaling(a,b)) {
    int factorA = _getScalingFactor(a);
    int factorB = _getScalingFactor(b);
    int ia = _scaleToInteger(a, factorA);
    int ib = _scaleToInteger(b, factorB);
    return (ia / ib) / (factorA*factorB);
  }
  else {
    return a / b;
  }  
}


int _scaleToInteger(double value, int factor) { return (value * factor).round(); }

double _fromScaledInteger(int scaledValue, int factor) {
  return scaledValue / factor;
}

bool _useScaling(double a, double b) {
  return _scalingEnabled && (!_isInteger(a) || !_isInteger(b));
}
bool _isInteger(double number) {
  return number.isFinite && number == number.truncateToDouble();
}


int _getScalingFactor(double number) {
  // todo om scaling ska användas
  int _factor = 100000000;
  return _factor;
}