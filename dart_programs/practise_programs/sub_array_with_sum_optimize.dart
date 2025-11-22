import 'dart:math';

void main() {
  List<int> arr = [-1, 1, 1];
  int k = 1;
  print(longestSubarrayWithSumK(arr, k)); // Output: 4 (subarray [5,2,7,1])
}

int longestSubarrayWithSumK(List<int> arr, int k) {
  Map<int, int> prefixMap = {};
  int sum = 0, maxLen = 0;
  int startIndex = -1, endIndex = -1;

  for (int i = 0; i < arr.length; i++) {
    sum += arr[i];

    if (sum == k) {
      // maxLen = max(maxLen, i+1);
      if (maxLen < i + 1) {
        maxLen = i + 1;
        startIndex = 0;
        endIndex = i;
      }
    }

    if (!prefixMap.containsKey(sum)) {
      prefixMap[sum] = i;
    }
    int rem = sum - k;
    if (prefixMap.containsKey(rem)) {
      int len = i - prefixMap[rem]!;
      //maxLen = max(maxLen, len);
      if (maxLen < len) {
        maxLen = len;
        startIndex = prefixMap[rem]! + 1;
        endIndex = i;
      }
    }
  }
  for (int i = startIndex; i <= endIndex; i++) print("${arr[i]}  num ${i + 1}");

  return maxLen;
}
