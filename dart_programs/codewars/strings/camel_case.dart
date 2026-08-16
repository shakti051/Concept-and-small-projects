
void main() {
  print(camelCase("hello case"));
  print(camelCase("pascal case word"));
}

String camelCase(String str) {
  if (str.isEmpty) return "";

  List<String> words = str.split(" ");
  return words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
  // return words
  //     .where((word) => word.isNotEmpty)
  //     .map((word) => word[0].toUpperCase() + word.substring(1))
  //     .join();
}
