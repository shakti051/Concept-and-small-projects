import 'dart:math';

void main() {
  String str = "tree";
  String result = frequencySort(str);
  print(result);
}

String frequencySort(String s) {
     Map<String, int> freq = {};

  for (var ch in s.split('')) {
    freq[ch] = (freq[ch] ?? 0) + 1;
  }

  var entries = freq.entries.toList();

  entries.sort((a, b) => b.value.compareTo(a.value));

  StringBuffer result = StringBuffer();

  for (var entry in entries) {
    result.write(entry.key * entry.value);
  }

  return result.toString();
  }