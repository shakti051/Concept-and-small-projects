

void main() {
  String str = "My name is Vikas";
  List<String> words = str.split(" ");
  String result = "";
  for (String word in words) {
    String revWord = "";
    for (int i = word.length - 1; i >= 0; i--) {
      revWord += word[i];
    }
    result += revWord + " ";
  }
  print(result.trim());
}
