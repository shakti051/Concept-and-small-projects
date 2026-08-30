// Let's say you are given the array {1,2,3,4,3,2,1}:
// Your function will return the index 3,
// because the sum of left side of the index ({1,2,3})
// and the sum of the right side of the index ({3,2,1}) both equal 6.

void main() {
  List<int> arr = [1, 2, 3, 4, 3, 2, 1];
  int result = -1;
  int totalSum = arr.fold(0, (sum, num) => sum + num);
  int leftSum = 0;

  for (var i = 0; i < arr.length; i++) {
    int rightSum = totalSum - leftSum - arr[i];
    if (rightSum == leftSum) {
      result = i;
      print(result);
      return;
    }
    leftSum += arr[i];
  }
  print(result);
}

// Time Complexity  = O(n)
// Space Complexity = O(1)
