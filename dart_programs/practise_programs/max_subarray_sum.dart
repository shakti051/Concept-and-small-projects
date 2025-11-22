
void main() {
  List<int> arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4];
  int n = arr.length;
  int maxSum = maxSubarraySum(arr, n);
  print("This is maxsum: $maxSum");
}

int maxSubarraySum(List<int> arr, int n) {
  int maxi = -1;
  int sum = 0;
  int start = 0;
  int ansStart = -1, ansEnd = -1;

  for (int i = 0; i < arr.length; i++) {
    if (sum == 0) start = i;
    sum += arr[i];
    if (sum < 0) sum = 0;
    if (sum > maxi) {
      maxi = sum;
      ansStart = start;
      ansEnd = i;
    }
  }

  for (int i = ansStart; i <= ansEnd; i++) print(arr[i]);

  return maxi;
}

