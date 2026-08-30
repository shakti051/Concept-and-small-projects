void waveSort(List<int> arr) {
  for (int i = 0; i < arr.length - 1; i++) {
    if ((i.isEven && arr[i] < arr[i + 1]) || (i.isOdd && arr[i] > arr[i + 1])) {
      final temp = arr[i];
      arr[i] = arr[i + 1];
      arr[i + 1] = temp;
    }
  }
}

void main() {
  final arr = [1, 4, 5, 3];

  waveSort(arr);

  print(arr);
}
