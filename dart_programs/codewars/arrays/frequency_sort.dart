// In this kata, you will sort elements in an array by decreasing frequency of elements. If two elements have the same frequency, sort them by increasing value.

// solve([2,3,5,3,7,9,5,3,7]) = [3,3,3,5,5,7,7,2,9]
// -- We sort by highest frequency to lowest frequency.
// -- If two elements have same frequency, we sort by increasing value.


void main() {
  final arr = [2, 3, 5, 3, 7, 9, 5, 3, 7];
  var result = frequencySort(arr);
  print(result);
}

List<int> frequencySort(List<int> arr) {
  Map<int, int> map = {};
  for (var num in arr) {
    map[num] = (map[num] ?? 0) + 1;
  }
  
  var entries = map.entries.toList();
  entries.sort((a, b) {
    if (a.value != b.value) {
      return b.value.compareTo(a.value);
    }
    return a.key.compareTo(b.key);
  });

  List<int> result = [];
  for (var entry in entries) {
    for (int i = 0; i < entry.value; i++) {
      result.add(entry.key);
    }
  }

  return result;
}


// void main() {
//   final arr = [2, 3, 5, 3, 7, 9, 5, 3, 7];

//   print(solve(arr));
// }

// List<int> solve(List<int> arr) {
//   // Step 1: Count frequency of each element
//   final frequency = <int, int>{};

//   for (final num in arr) {
//     frequency[num] = (frequency[num] ?? 0) + 1;
//   }

//   // Step 2: Get unique elements
//   final elements = frequency.keys.toList();

//   // Step 3: Sort using the required rules
//   elements.sort((a, b) {
//     final freqA = frequency[a]!;
//     final freqB = frequency[b]!;

//     // Higher frequency first
//     if (freqA != freqB) {
//       return freqB.compareTo(freqA);
//     }

//     // Same frequency -> smaller value first
//     return a.compareTo(b);
//   });

//   // Step 4: Build the final result
//   final result = <int>[];

//   for (final num in elements) {
//     final count = frequency[num]!;

//     for (int i = 0; i < count; i++) {
//       result.add(num);
//     }
//   }

//   return result;
// }