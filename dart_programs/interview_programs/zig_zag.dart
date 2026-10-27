//
void zigZag(List<int> arr) {
  for (int i = 0; i < arr.length - 1; i++) {
    if (i % 2 == 0) {
      // Even index: arr[i] < arr[i + 1]
      if (arr[i] > arr[i + 1]) {
        _swap(arr, i, i + 1);
      }
    } else {
      // Odd index: arr[i] > arr[i + 1]
      if (arr[i] < arr[i + 1]) {
        _swap(arr, i, i + 1);
      }
    }
  }
}

_swap(List<int> arr, int i, int j) {
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

void main() {
  final arr = [4, 3, 7, 8, 6, 2, 1];

  zigZag(arr);

  print(arr);
}
