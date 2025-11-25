import 'package:decimal/decimal.dart';  

Decimal operationAdd(Decimal a, Decimal b) {
    return a + b;
}
Decimal operationSubtract(Decimal a, Decimal b) {
    return a - b;
}
Decimal operationMultiply(Decimal a, Decimal b) {
    return a * b;
}
Decimal operationDivide(Decimal a, Decimal b) {
  if (b == Decimal.zero) throw Exception('Division med noll');
  return (a / b).toDecimal(scaleOnInfinitePrecision: 10); 
}