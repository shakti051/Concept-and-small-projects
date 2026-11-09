//

void main() {
  List<int> arr = [2, 2, 1, 1, 1, 2, 2];
  int ans = majorityElement(arr);
  print(ans);
}
//
int majorityElement(List<int> arr) {
  int element = 0;
  int count = 0;
  
  for (int num in arr) {
    if (count == 0) element = num;
    if (num == element)
      count++;
    else
      count--;
    if (count > arr.length / 2) return element;
  }
  
  int freq = 0;
  for (var num in arr) {
    if (num == element) {
      freq++;
    }
    if (freq > arr.length / ~2) {
      print(element);
    }
  }
  return element;
}