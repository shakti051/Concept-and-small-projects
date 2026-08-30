
void main() {
  List<int> arr = [1, 2, 3, 4, 5];
  List<int> temp = List.filled(arr.length, 0);
  int n = arr.length;
  int k = -1;
  // Convert left rotation to right rotation.
  if(k<0)
  {
    k+=n;
  }

  for (var i = 0; i < arr.length; i++) {
    temp[(i + k) % n] = arr[i];
  }
  // print(temp);
  arr.setAll(0, temp);
  print(arr);
}
