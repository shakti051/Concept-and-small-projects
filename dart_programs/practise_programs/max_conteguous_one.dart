

void main() {
  List<int> arr = [1, 1, 0, 1, 1, 1];
  int count = 0;
  int max = 0;
  for (int num in arr) {
    if (num == 1) {
      count++;
    } else {
      count = 0;
    }
    max = count > max ? count : max;
  }
  print("The max consecutive ones are: $max");
}

