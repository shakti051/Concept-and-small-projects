List<dynamic> moveZeros(List<dynamic> arr) {
  int j = 0;

  // Move non-zeros forward
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] != 0) {
      var temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;

      j++;
    }
  }

  return arr;
}

void main() {
  print(moveZeros([false,1,0,1,2,0,1,3,"a"]));
}