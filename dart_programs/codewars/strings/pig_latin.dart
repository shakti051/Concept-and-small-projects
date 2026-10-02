//https://www.codewars.com/kata/558878ab7591c911a4000007/train/java

String? translate(String str) {
  // 1. Input must contain only alphabets
  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(str)) {
    return null;
  }

  // 2. Convert to lowercase
  str = str.toLowerCase();

  // 3. Starts with a vowel
  if (isVowel(str[0])) {
    return '${str}way';
  }

  // 4. Find the first vowel
  int firstVowel = -1;

  for (int i = 0; i < str.length; i++) {
    if (isVowel(str[i])) {
      firstVowel = i;
      break;
    }
  }

  // 5. No vowel
  if (firstVowel == -1) {
    return '${str}ay';
  }

  // 6. Move consonants to the end
  String prefix = str.substring(0, firstVowel);
  String remaining = str.substring(firstVowel);

  return '${remaining}${prefix}ay';
}

bool isVowel(String ch) {
  return ch == 'a' ||
      ch == 'e' ||
      ch == 'i' ||
      ch == 'o' ||
      ch == 'u';
}

void main() {
  print(translate('spaghetti')); // aghettispay
  print(translate('apple'));     // appleway
  print(translate('banana'));    // ananabay
  print(translate('rhythms'));   // rhythmsay
  print(translate('HELLO'));     // ellohay
  print(translate('hello123'));  // null
}