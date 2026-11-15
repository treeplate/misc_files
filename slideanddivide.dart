import 'dart:io';

void main() {
  while(true) {
    print('ax^2 + bx + c');
    print('a: ');
    int a = int.parse(stdin.readLineSync()!);
    print('b: ');
    int b = int.parse(stdin.readLineSync()!);
    print('c: ');
    int c = int.parse(stdin.readLineSync()!);
    int diamondProduct = a * c;
    print('Pick a number y such that $diamondProduct / y = $b - y:');
    int partialResultLhs = -100;
    while(diamondProduct / partialResultLhs != b - partialResultLhs) {
      if (partialResultLhs != -100) {
        print('${diamondProduct/partialResultLhs} != ${b-partialResultLhs}, try again:');
      }
      partialResultLhs = int.parse(stdin.readLineSync()!);
    }
    print('Partial result: (x + $partialResultLhs)(x + ${b-partialResultLhs})');
    print('Find the GCF of $partialResultLhs and $a');
    int lhsGcf = int.parse(stdin.readLineSync()!);
    print('Find the GCF of ${b-partialResultLhs} and $a');
    int rhsGcf = int.parse(stdin.readLineSync()!);
    print('Final result: $a(${a/lhsGcf}x + ${partialResultLhs/lhsGcf})(${a/rhsGcf}x + ${(b-partialResultLhs)/rhsGcf})');
  }
}