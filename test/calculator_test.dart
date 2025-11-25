import 'package:decimal/decimal.dart';
import 'package:flutter_calculator/utils/expression/expression_calculator.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

 test('1', () {
      Decimal result = calculateExpression("3,2(2*3,63+2,23)");
      expect(result.toString(), '30.368');  
    });
test('1b', () {
      Decimal result = calculateExpression("(3(2*(1+2)))");
      expect(result.toString(), '18');  
    });
     test('2', () {
      Decimal result = calculateExpression("3(2+25)(1-2*1)");
      expect(result.toString(), '-81');  
    });

    test('3', () {
      Decimal result = calculateExpression("4*(1+2(1-4))");
      expect(result.toString(), '-20'); 
    });

    test('4', () {
      Decimal result = calculateExpression("(4)(2)");
      expect(result.toString(), '8');  
    });

     test('5', () {
      Decimal result = calculateExpression("(5)(3/3)");
      expect(result.toString(), '5');  
    });

     test('6', () {
      Decimal result = calculateExpression("3(2)");
      expect(result.toString(), '6'); 
    });

    test('7', () {
      Decimal result = calculateExpression("100000,0000001*100000,0000001");
      expect(result.toString(), '10000000000.02000000000001'); 
    });

    test('8', () {
      Decimal result = calculateExpression("100000*100000,1");
      expect(result.toString(), '10000010000'); 
    });
}
  

