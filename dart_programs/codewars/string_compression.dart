
//**
//**If the string were "aaabbc", return "3a2b1c".
//If the string were "xxyz", return "2x1y1z".**//

String encode(String s) {
  if (s.isEmpty) return "";

  StringBuffer result = StringBuffer();

  String current = s[0];
  int count = 1;

  for (int i = 1; i < s.length; i++) {
    if (s[i] == current) {
      count++;
    } else {
      result.write('$count$current');
      current = s[i];
      count = 1;
    }
  }
  // last block
  result.write('$count$current');

  return result.toString();
}

void main() {
  print(encode("aaabbccc")); // 3a2b1c
  print(encode("xxyz"));   // 2x1y1z
}
