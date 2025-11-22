void main() {
  List<int> arr = [3, 1, 2, 5, 4, 6, 7, 5];
  List<int> ans = findMissingRepeatingNumbers(arr);
  print(ans);
}

List<int> findMissingRepeatingNumbers(List<int> arr) {
  int repeating = -1;
  int missing = -1;
  for (int i = 1; i <= arr.length; i++) {
    int count = 0;
    for (int num in arr) {
      if (num == i) count++;
    }
    if (count == 2) repeating = i;
    if (count == 0) missing = i;
  }
  return [repeating, missing];
}
