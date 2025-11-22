
void main() {
  List<int> arr = [3, 1, -2, -5, 2, -4];
  int posIndex = 0;
  int negIndex = 1;
  List<int> temp = List.filled(arr.length, 0);
  for (int num in arr) {
    if (num > 0) {
      temp[posIndex] = num;
      posIndex += 2;
    } else {
      temp[negIndex] = num;
      negIndex += 2;
    }
  }
  print(temp);
}
