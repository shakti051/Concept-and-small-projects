
void main() {
  List<int> arr = [2, 5, 1, 3, 0];
  // int max = arr[0];
  // for (int num in arr)
  //  {
  //   if (num > max) max = num;
  // }
  int max = arr.reduce((curr,next)=> curr>next ? curr:next);
  print("The largest element is $max");
}
