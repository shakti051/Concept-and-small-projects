import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/math_utils.dart';

void main() {
  group('"Math utils -"', () {
    test("Addition", () {
      var a = 10;
      var b = 10;
      var sum = add(a, b);
      expect(sum, 20);
    });

    test("Multiplication", () {
      var a = 10;
      var b = 10;
      var sum = multipy(a, b);
      expect(sum, 100);
    });

    test("subtract", () {
      var a = 10;
      var b = 10;
      var sum = substract(a, b);
      expect(sum, 0);
    });

    test("Divide", () {
      var a = 10;
      var b = 10;
      // if (b == 0) {
      //   expect(() => divide(a, b), throwsException);
      // }
      var sum = divide(a, b);
      expect(sum, 1);
    });
  });
}
