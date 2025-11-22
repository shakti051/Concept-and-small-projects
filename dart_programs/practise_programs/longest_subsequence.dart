import 'dart:math';

void main() {
  List<int> arr = [100, 200, 1, 2, 3, 4];
  int ans = longestSuccessiveElements(arr);
  print("The longest sequence $ans");
}

int longestSuccessiveElements(List<int> arr) {
  int longest = 0;
  Set<int> integerSet = <int>{};
  for (int num in arr) integerSet.add(num);
  for (int num in integerSet) {
    if (!integerSet.contains(num - 1)) {
      int x = num;
      int count = 1;
      while (integerSet.contains(x + 1)) {
        x++;
        count++;
      }
      longest = max(count, longest);
    }
  }
  return longest;
}
