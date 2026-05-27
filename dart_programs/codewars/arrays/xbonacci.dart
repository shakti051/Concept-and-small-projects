
List<num> xbonacci(List<num> signature, int n) {
  int x = signature.length;

  // If n is smaller than signature length
  if (n <= x) {
    return signature.sublist(0, n);
  }

  List<num> result = List.from(signature);

  // Initial window sum
  num windowSum = signature.reduce((a, b) => a + b);

  // Generate remaining elements
  for (int i = x; i < n; i++) {

    // Next element is current window sum
    result.add(windowSum);

    // Sliding window update
    windowSum = windowSum + result[i] - result[i - x];
  }

  return result;
}

void main() {
  print(xbonacci([1, 1, 1, 1], 10));
  // [1, 1, 1, 1, 4, 7, 13, 25, 49, 94]

  print(xbonacci([0, 0, 0, 0, 1], 10));
  // [0, 0, 0, 0, 1, 1, 2, 4, 8, 16]

  print(xbonacci([1, 1], 10));
  // Fibonacci sequence
}
