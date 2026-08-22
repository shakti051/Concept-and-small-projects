
void main() {
  List<int> arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4];

  int maxSum = arr[0];
  int currentSum = arr[0];

  int start = 0;
  int end = 0;
  int tempStart = 0;

  for (int i = 1; i < arr.length; i++) {
    if (arr[i] > currentSum + arr[i]) {
      currentSum = arr[i];
      tempStart = i;
    } else {
      currentSum += arr[i];
    }

    if (currentSum > maxSum) {
      maxSum = currentSum;
      start = tempStart;
      end = i;
    }
  }

  print("Maximum Sum: $maxSum");
  print("Subarray: ${arr.sublist(start, end + 1)}");
}