void main() {
  List<int> existingPins = [0000, 9000, 9900, 9990];
  StringBuffer buf = StringBuffer();
  int goal = 1;
  int current = 0;
  buf.write('0000');
  while (goal <= 9999) {
    int newDigit = 0;
    if (current % 1000 == goal ~/ 10) {
      newDigit = goal % 10;
    } else if (current % 100 == goal ~/ 100) {
      newDigit = (goal % 100) ~/ 10;
    } else if (current % 10 == goal ~/ 1000) {
      newDigit = (goal % 1000) ~/ 100;
    } else {
      newDigit = goal ~/ 1000;
    }
    buf.write(newDigit);
    current *= 10;
    current %= 10000;
    current += newDigit;
    existingPins.add(current);
    while (existingPins.contains(goal)) {
      goal++;
    }
  }
  buf.write('000');
  print(buf.toString());
}
