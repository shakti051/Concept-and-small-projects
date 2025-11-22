
void main() {
  List<int> arr = [1, 2, 3, 4, 5];
  bool isSorted = true;
  for (int i = 1; i < arr.length; i++) {
    if (arr[i] < arr[i - 1]) {
      isSorted = false;
      break;
    }
  }   
 print("The array sorted status is: $isSorted");
}
