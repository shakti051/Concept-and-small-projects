import 'dart:math';

void main() {
  List<int> arr = [-1, 1, 1];
  int k = 1;
  int maxSubArrayLen = greatestSubArrayWithSum(arr, k);
  print("Max subArray with given sum: $maxSubArrayLen");
}

int greatestSubArrayWithSum(List<int> arr, int k) {
  int len = 0;
  for (int i = 0; i < arr.length; i++) {
    int sum = 0;
    for (int j = i; j < arr.length; j++) {
      sum += arr[j];
      if (sum == k) {
        len = max(len, j - i + 1);
      }
    }
  }
  return len;
}
