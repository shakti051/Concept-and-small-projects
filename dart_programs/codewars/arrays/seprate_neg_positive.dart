
void main() {
  final result = wheatFromChaff([7, -8, 1, -2]);
  print(result);
}


List<int> wheatFromChaff(List<int> values) {
  int n = values.length;
  List<int> temp = List.filled(n, 0);

  int negIndex = 0;
  int posIndex = n - 1;

  for (var num in values) {
    if (num < 0) {
      temp[negIndex++] = num;
    } else {
      temp[posIndex--] = num;
    }
  }
  
  return temp;
}

