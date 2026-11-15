void main() {
  List<String> words = [
    'PIGS',
    'SAND',
    'MAIL',
    'DATE',
    'HEAD',
    'CLAM',
    'PEAK',
    'SAND',
    'JOYA',
    'WELL',
    'TOAD',
    'CARD',
    'WILL',
    'TAPE',
    'LEGS',
    'TREE',
    'ROAD',
    'MAID',
    'SLAB',
    'ROCK',
    'HAND',
    'VASE',
    'SAFE',
    'CLAY',
    'TOES',
  ];
  Set<(String, String)> pairs = {};
  for (String word in words) {
    for (String w2 in words) {
      if (word == w2) continue;
      int i = 0;
      while (i < 4) {
        if ((word.codeUnits.toList()..remove(word[i].codeUnits.single)).every(
          (e) => w2.codeUnits.contains(e),
        )) {
          if (!pairs.contains((word, w2)) && !pairs.contains((w2, word))) {
            pairs.add((word, w2));
            print('$word $w2 (${word[i]})');
          }
        }
        i++;
      }
    }
  }
}
