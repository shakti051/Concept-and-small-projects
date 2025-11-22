
void main() {
  List<int> arr = [3, 1, 2, 4];
  int k = 6;
  int cnt = findAllSubarraysWithGivenSum(arr, k);
  print("The number of subarrays is: $cnt");
}

int findAllSubarraysWithGivenSum(List<int> arr, int k) {
  int count = 0;
  Map<int, int> prefixSumCount = {0: 1};
  int sum = 0;

  for (int num in arr) {
    sum += num;
    int rem = sum - k;
    if (prefixSumCount.containsKey(rem)) {
      count += prefixSumCount[rem]!;
    }
    prefixSumCount[sum] = (prefixSumCount[sum] ?? 0) + 1;
  }
  return count;
}
