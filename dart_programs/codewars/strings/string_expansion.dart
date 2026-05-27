//Rule 1: Digits decide repetition count
//Rule 2: Consecutive digits → only last digit matters

String stringExpansion(String s) {
  StringBuffer result = StringBuffer();
//  String result = "";
  int repeat = 1;

  for (int i = 0; i < s.length; i++) {
    String ch = s[i];

    // If character is digit, update repeat count
    if (RegExp(r'\d').hasMatch(ch)) {
      repeat = int.parse(ch);
    } else {
      // Repeat current character
      result.write(ch * repeat);
     // result += ch * repeat;
    }
  }

  return result.toString();
}

void main() {
  print(stringExpansion("3D2a5d2f"));
  // DDDaadddddff

  print(stringExpansion("3abc"));
  // aaabbbccc

  print(stringExpansion("3d332f2a"));
  // dddffaa

  print(stringExpansion("abcde"));
  // abcde

  print(stringExpansion("1111"));
  // ""

  print(stringExpansion(""));
  // ""
}
