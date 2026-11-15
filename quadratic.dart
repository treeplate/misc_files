import 'dart:io';
import 'dart:math' as math;

void main() {
  while (true) {
    int a = int.parse(stdin.readLineSync()!);
    int b = int.parse(stdin.readLineSync()!);
    int c = int.parse(stdin.readLineSync()!);
    Complex sqrtB2_4ac = Complex.sqrt(b * b - 4 * a * c);
    print('(${(sqrtB2_4ac)} - $b)/${2*a}');
    print('(-${(sqrtB2_4ac)} - $b)/${2*a}');
  }
}

class Sqrt {
  final int value;

  String toString() {
    if (math.sqrt(value).truncate() == math.sqrt(value)) {
      return math.sqrt(value).toStringAsFixed(0);
    } else {
    int temp = value;
    int mul = 1;
    if((temp/4).truncate() == temp/4) {
      mul *= 2;
      temp ~/= 4;
    }
    if((temp/9).truncate() == temp/9) {
      mul *= 3;
      temp ~/= 9;
    }
    if((temp/16).truncate() == temp/16) {
      mul *= 4;
      temp ~/= 16;
    }
    if((temp/25).truncate() == temp/25) {
      mul *= 5;
      temp ~/= 25;
    }
    if((temp/36).truncate() == temp/36) {
      mul *= 6;
      temp ~/= 36;
    }
    if(mul == 1) {
      return 'sqrt($temp)';
    }
      return '($mul sqrt($temp))';
    }
  }

  Sqrt(this.value);
}

class Complex {
  final Sqrt a;
  final Sqrt b;

  String toString() => a.value == 0
      ? b.toString()
      : '${a.toString()}i+${b.toString()}';

  static Complex sqrt(int value) {
    if (value.isNegative) {
      return Complex(Sqrt(-value), Sqrt(0));
    } else {
      return Complex(Sqrt(0), Sqrt(value));
    }
  }

  Complex(this.a, this.b);
}
