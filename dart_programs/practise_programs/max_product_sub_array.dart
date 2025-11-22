import 'dart:math';

void main() {
  List<int> arr = [2, 3, -2, 4];
  int max = maxProduct(arr);
  print("The max sub array product: $max");
}

int maxProduct(List<int> arr) {
  int result = -1;
  int prefix = 1;
  int suffix = 1;
  int n = arr.length;
  for (int i = 0; i < arr.length; i++) {
    if (prefix == 0) prefix = 1;
    if (suffix == 0) suffix = 1;
    prefix *= arr[i];
    suffix *= arr[n - i - 1];
    result = max(result, max(prefix, suffix));
  }
  return result;
}
