import 'dart:math';
//

void main() {
  String str = "treaaae";
  String result = frequencySort(str);
  print(result);
}

String frequencySort(String s) {
  Map<String, int> freq = {};

  for (var ch in s.split('')) {
    freq[ch] = (freq[ch] ?? 0) + 1;
  }

  var entries = freq.entries.toList();
  print(freq.keys.toList());  
  //entries.sort((a, b) => b.value.compareTo(a.value));
  entries.sort((a, b) {
    if (a.value != b.value) {
      return b.value.compareTo(a.value);
    }

    return a.key.compareTo(b.key);
  });

  StringBuffer result = StringBuffer();

  for (var entry in entries) {
    result.write(entry.key * entry.value);
  }

  return result.toString();
}
