

void main() {
  print(encryptThis("Hello"));
  print(encryptThis("good"));
  print(encryptThis("hello world"));
}

String encryptThis(String text) {
  List<String> words = text.split(' ');

  List<String> result = [];

  for (String word in words) {
    if (word.length == 1) {
      result.add(word.codeUnitAt(0).toString());
      continue;
    }

    if (word.length == 2) {
      result.add('${word.codeUnitAt(0)}${word[1]}');
      continue;
    }

    String firstAscii = word.codeUnitAt(0).toString();

    String encrypted =
        firstAscii +
        word[word.length - 1] +
        word.substring(2, word.length - 1) +
        word[1];

    result.add(encrypted);
  }
  
  return result.join(' ');
}
