// A simple form of RLE would encode the string "AAABBBCCCD" as "3A3B3C1D" 
// meaning, first there are 3 A, then 3 B, then 3 C and last there is 1 D.
//https://www.codewars.com/kata/578bf2d8daa01a4ee8000046
String encode(String text) {
  if (text.isEmpty) {
    return '';
  }

  final result = StringBuffer();

  int count = 1;

  for (int i = 1; i < text.length; i++) {
    if (text[i] == text[i - 1]) {
      count++;
    } else {
      result.write(count);
      result.write(text[i - 1]);
      count = 1;
    }
  }

  // Add the final run
  result.write(count);
  result.write(text[text.length - 1]);

  return result.toString();
}


void main() {
  print(encode("AAABBBCCCDD"));
}

