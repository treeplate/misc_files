import 'dart:math';

int pick(int left, int num, int maxRoll, int Function(int) score) {
  if (left == 0) return left;
  Set<int> options = {if (left & (1 << num) != 0) left ^ (1 << num)};
  int num2 = 1;
  while (num2 * 2 < num) {
    if (left & (1 << num2) != 0 && left & (1 << (num - num2)) != 0) {
      options.add(left ^ ((1 << num2) | (1 << (num - num2))));
    }
    num2++;
  }
  int bestScore = 10000;
  int bestOption = left;
  if (options.length == 1) {
    return options.single;
  }
  for (int option in options) {
    int sum = 0;
    int roll1 = 1;
    while (roll1 <= maxRoll) {
      int roll2 = 1;
      while (roll2 <= maxRoll) {
        sum += score(pick(option, roll1 + roll2, maxRoll, score));
        roll2++;
      }
      roll1++;
    }
    if (sum < bestScore) {
      bestOption = option;
      bestScore = sum;
      if (bestScore == 0) {
        return bestOption;
      }
    }
  }
  return bestOption;
}

String bitFieldToStr(int field) {

  int n = 1;
  StringBuffer result = StringBuffer();
  while(1 << n <= field) {
    if ((1 << n) & field != 0) {
      result.write('$n ');
    }
    n++;
  }
  return result.toString();
}

int sum(int left) {
  int n = 1;
  int result = 0;
  while(1 << n <= left) {
    if ((1 << n) & left != 0) {
      result += n;
    }
    n++;
  }
  return result;
}

int won(int left) => left == 0 ? 0 : 1;

void main(List<String> arguments) {
  Random r = Random();
  int n = 6;
  int box = (1 << 2*n+1) - 1;
  int roll = r.nextInt(n) + r.nextInt(n) + 2;
  while (true) {
  print('rolled $roll');
        Set<int> options = {if (box & (1 << roll) != 0) box ^ (1 << roll)};
  int num = 1;
  while (num * 2 < roll) {
    if (box & (1 << num) != 0 && box & (1 << (roll - num)) != 0) {
      options.add(box ^ ((1 << num) | (1 << (roll - num))));
    }
    num++;
  }
  if(options.isEmpty) {
    break;
  }
    print(
      bitFieldToStr(box = pick(
        box,
        roll,
        n,
        sum,
      )),
    );
    roll = r.nextInt(n) + r.nextInt(n) + 2;
  }
  print(sum(box));
}
