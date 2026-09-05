//https://www.codewars.com/kata/5e8dd197c122f6001a8637ca/java
// Rules
// Whenever two keys share the same character, they should be compared numerically, and the larger key will keep that character. That's why in the example above the array under the key "2" contains "A" and "B", as 2 > 1.
// If duplicate characters are found in the same array, the first occurance should be kept.



Map<int, List<String>> removeDuplicateIds(
  Map<int, List<String>> obj,
) {
  final seen = <String>{};
  print(seen.runtimeType);
  // Process keys from largest to smallest.
  final sortedEntries = obj.entries.toList()
    ..sort((a, b) => b.key.compareTo(a.key));

  final result = <int, List<String>>{};
  print(result.runtimeType);
  
  for (final entry in sortedEntries) {
    final unique = <String>[];

    for (final id in entry.value) {
      // add() returns true if the value was not already present.
      if (seen.add(id)) {
        unique.add(id);
      }
    }

    result[entry.key] = unique;
  }

  return result;
}

void main() {
  final input = {
    1: ['C', 'F', 'G'],
    2: ['A', 'B', 'C'],
    3: ['A', 'B', 'D'],
  };

  final result = removeDuplicateIds(input);

  print(result);
}


// Map<String, List<String>> solve(Map<String, List<String>> input) {
//   // First: remove duplicates inside each array.
//   final cleaned = <String, List<String>>{};

//   for (final entry in input.entries) {
//     final seen = <String>{};
//     final uniqueChars = <String>[];

//     for (final ch in entry.value) {
//       if (seen.add(ch)) {
//         uniqueChars.add(ch);
//       }
//     }

//     cleaned[entry.key] = uniqueChars;
//   }

//   // Find the largest key that owns each character.
//   final owner = <String, String>{};

//   for (final entry in cleaned.entries) {
//     final key = entry.key;
//     final numericKey = int.parse(key);

//     for (final ch in entry.value) {
//       if (!owner.containsKey(ch) ||
//           numericKey > int.parse(owner[ch]!)) {
//         owner[ch] = key;
//       }
//     }
//   }

//   // Build the result.
//   final result = <String, List<String>>{};

//   for (final entry in cleaned.entries) {
//     final key = entry.key;
//     final chars = <String>[];

//     for (final ch in entry.value) {
//       if (owner[ch] == key) {
//         chars.add(ch);
//       }
//     }

//     result[key] = chars;
//   }

//   return result;
// }

// void main() {
//   final input = {
//     '1': ['C', 'F', 'G'],
//     '2': ['A', 'B', 'C'],
//     '3': ['A', 'B', 'D'],
//   };

//   final result = solve(input);

//   print(result);
// }