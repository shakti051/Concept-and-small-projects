// Write a function that takes two strings, A and B, and returns the length of the longest possible substring that can be formed from the concatenation of either A + B or B + A containing only characters that do not appear in both A and B.

// Example:
// Given the strings "piquancy" and "refocusing":
// A = "piquancy"
// B = "refocusing"
// A + B = "piquancyrefocusing"
// B + A = "refocusingpiquancy"

// Since 'i', 'n', 'u', and 'c' appear in both A and B, all acceptable substrings without those characters are:
// "p", "q", "a", "yrefo", "s", "g" (from A + B)
// "refo", "s", "gp", "q", "a", "y" (from B + A)

// Therefore, it would be correct to return 5: the length of "yrefo".


class FindSubstring {
  static int longestSubstring(String a, String b) {
    final setA = <String>{};
    final setB = <String>{};

    // Characters present in A
    for (final ch in a.split('')) {
      setA.add(ch);
    }

    // Characters present in B
    for (final ch in b.split('')) {
      setB.add(ch);
    }

    // Characters present in BOTH A and B
    final forbidden = <String>{...setA};
    forbidden.retainAll(setB);

    // No common characters.
    if (forbidden.isEmpty) {
      return a.length + b.length;
    }

    final combined = '$a$b$a';

    int current = 0;
    int maxLength = 0;

    for (final ch in combined.split('')) {
      if (forbidden.contains(ch)) {
        if (current > maxLength) {
          maxLength = current;
        }

        current = 0;
      } else {
        current++;
      }
    }

    // Check the final substring.
    if (current > maxLength) {
      maxLength = current;
    }

    return maxLength;
  }
}

void main() {
  final result = FindSubstring.longestSubstring(
    'piquancy',
    'refocusing',
  );

  print(result); // 5
}

// Time Complexity  : O(n + m)
// Space Complexity : O(n + m)

// class FindSubstring {
//   static String longestSubstring(String a, String b) {
//     final setA = <String>{};
//     final setB = <String>{};

//     for (final ch in a.split('')) {
//       setA.add(ch);
//     }

//     for (final ch in b.split('')) {
//       setB.add(ch);
//     }

//     // Keep only characters that appear in both A and B.
//     setA.retainAll(setB);

//     // No common characters => the whole concatenation is valid.
//     if (setA.isEmpty) {
//       return '$a$b';
//     }

//     final combined = '$a$b$a';

//     int currentLength = 0;
//     int currentStart = 0;

//     int maxLength = 0;
//     int maxStart = 0;

//     for (int i = 0; i < combined.length; i++) {
//       final ch = combined[i];

//       if (setA.contains(ch)) {
//         if (currentLength > maxLength) {
//           maxLength = currentLength;
//           maxStart = currentStart;
//         }

//         currentLength = 0;
//         currentStart = i + 1;
//       } else {
//         if (currentLength == 0) {
//           currentStart = i;
//         }

//         currentLength++;
//       }
//     }

//     // Check the final valid substring.
//     if (currentLength > maxLength) {
//       maxLength = currentLength;
//       maxStart = currentStart;
//     }

//     return combined.substring(maxStart, maxStart + maxLength);
//   }
// }

// void main() {
//   const a = 'piquancy';
//   const b = 'refocusing';

//   final result = FindSubstring.longestSubstring(a, b);

//   print('Longest substring: $result');
//   print('Length: ${result.length}');
// }