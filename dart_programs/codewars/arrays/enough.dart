//Delete occurrences of an element if it occurs more than n times

List<int> deleteNth(List<int> elements, int maxOccurrences) {
  final Map<int, int> countMap = {};
  final List<int> result = [];

  for (final num in elements) {
    final count = countMap[num] ?? 0;

    if (count < maxOccurrences) {
      result.add(num);
      countMap[num] = count + 1;
    }
  }

  return result;
}

void main() {
  final result = deleteNth(
    [1, 2, 3, 1, 2, 1, 2, 3],
    2,
  );

  print(result);
}