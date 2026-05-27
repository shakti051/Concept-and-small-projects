//Minor Words Stay Lowercase
//Exception to the exception:
//The first word is always capitalized.

String titleCase(String title, [String? minorWords]) {
  if (title.isEmpty) return "";

  // Convert minor words into a Set for fast lookup
  Set<String> minorSet =
      (minorWords ?? "").toLowerCase().split(" ").toSet();

  List<String> words = title.toLowerCase().split(" ");

  for (int i = 0; i < words.length; i++) {
    String word = words[i];

    // First word is always capitalized
    if (i == 0 || !minorSet.contains(word)) {
      words[i] =
          word[0].toUpperCase() + word.substring(1);
    }
  }

  return words.join(" ");
}

void main() {
  print(titleCase('a clash of KINGS', 'a an the of'));
  // A Clash of Kings

  print(titleCase('THE WIND IN THE WILLOWS', 'The In'));
  // The Wind in the Willows

  print(titleCase('the quick brown fox'));
  // The Quick Brown Fox
}