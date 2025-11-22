
import 'dart:io';
//***Count frequency of element in a String **//
void main() {
  String str = "Hello Wordd";
  str = str.replaceAll(" ", ""); // remove spaces

  Map<String, int> map = {}; // Dart's Map instead of HashMap

  for (int i = 0; i < str.length; i++) {
    String ch = str[i];
    map[ch] = (map[ch] ?? 0) + 1; // same as getOrDefault in Java
  }

  // print result
  print(map);
  // map.forEach((key, value) {
  //   stdout.write("$key:$value,");
  // });
}
