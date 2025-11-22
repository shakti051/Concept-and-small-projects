
void main() {
  List<int> arr = [4, 1, 2, 1, 2];
  int result = 0;
  for (int num in arr) {
    result = result ^ num;
  }
  print("Single appear number: $result");
}
