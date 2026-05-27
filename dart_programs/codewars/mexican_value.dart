
List<String> wave(String str) {
  List<String> result = [];

  for (var i = 0; i < str.length; i++) {
    if (str[i] == " ") continue;
    result.add(
      str.substring(0, i) + str[i].toUpperCase() + str.substring(i + 1),
    );
  }
  return result;
}

void main() {
  print(wave("hello"));
  print(wave(" s p a c e s "));
}
