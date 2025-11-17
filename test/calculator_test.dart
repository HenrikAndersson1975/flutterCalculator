import 'package:flutter_calculator/utils/expression/expression_calculator.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

 test('1', () {
      double result = calculateExpression("3,2(2*3,63+2,23)");
      expect(result, 30.368);  
    });
test('1b', () {
      double result = calculateExpression("(3(2*(1+2)))");
      expect(result, 18);  
    });
     test('2', () {
      double result = calculateExpression("3(2+25)(1-2*1)");
      expect(result, -81);  
    });

    test('3', () {
      double result = calculateExpression("4*(1+2(1-4))");
      expect(result, -20); 
    });

    test('4', () {
      double result = calculateExpression("(4)(2)");
      expect(result, 8);  
    });

     test('5', () {
      double result = calculateExpression("(5)(3/3)");
      expect(result, 5);  
    });

     test('6', () {
      double result = calculateExpression("3(2)");
      expect(result, 6); 
    });

    /*test('7', () {
      double result = calculateExpression("100000,0000001*100000,0000001");
      expect(result, 10000000000.02000000000001); 
    });*/

    test('8', () {
      double result = calculateExpression("100000*100000,1");
      expect(result, 10000010000); 
    });
}
  

