
void main() {
  List<int> arr = [10, 5, 10, 15, 10, 5];
  Map<int, int> frequency = {};

  for (int num in arr) 
  {
    frequency[num] = (frequency[num] ?? 0) + 1;
  }

  frequency.forEach((key, value) {
    print('$key occurs $value times');
  });

}
