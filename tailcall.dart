sealed class TCFunctionResult<P,R> {}

class TCFunctionCallResult<P, R> extends TCFunctionResult<P, R> {
  final TCFunction<P,R> tailCalled;
  final P parameter; // used if tailCalled != null

  TCFunctionCallResult(this.tailCalled, this.parameter);
}

class TCFunctionReturnResult<P, R> extends TCFunctionResult<P, R> {
  final R result;
  
  TCFunctionReturnResult(this.result);
}

typedef TCFunction<P, R> = TCFunctionResult<P, R> Function(P);

R callWithTC<P, R>(TCFunction<P, R> function, P parameter) {
  while (true) {
    TCFunctionResult<P, R> tcResult = function(parameter);
    if (tcResult is TCFunctionCallResult<P, R>) {
      parameter = tcResult.parameter;
      function = tcResult.tailCalled;
    } else {
      return (tcResult as TCFunctionReturnResult).result;
    }
  }
}

/* example:
void main() {
  String result = callWithTC(cat, 10);
  print('final: $result');
}

TCFunctionResult<int, String> cat(int iterations) {
  print('meow! ($iterations)');
  if (iterations == 0) {
  return TCFunctionReturnResult('meow!');
  }
  return TCFunctionCallResult(cat, iterations - 1);
}
*/

// test.dart //
import 'tailcall.dart';

void main() {
  String result = callWithTC(cat, 10);
  print('final: $result');
}

TCFunctionResult<int, String> cat(int iterations) {
  print('meow! ($iterations)');
  if (iterations == 0) {
    throw 'meow';
  }
  return TCFunctionCallResult(cat, iterations - 1);
}
