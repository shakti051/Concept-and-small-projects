//https://www.codewars.com/kata/5be350bcce5afad8020000d6/train/java


void main() {
  final result = maxMatch("xday");//happyday

  print(result);
}

List<String> maxMatch(String sentence) {
  final List<String> result = [];

  final validWords = {
  "happy",
  "day",
  "he",
  "hello",
  "world",
};

  int start = 0;

  while (start < sentence.length) {
    bool found = false;

    // Try the longest possible word first
    for (int end = sentence.length; end > start; end--) {
      final word = sentence.substring(start, end);

      if (validWords.contains(word)) {
        result.add(word);

        start = end;
        found = true;
        break;
      }
    }

    // If no valid word is found,
    // take the first character as a word.
    if (!found) {
      result.add(sentence[start]);
      start++;
    }
  }

  return result;
}

