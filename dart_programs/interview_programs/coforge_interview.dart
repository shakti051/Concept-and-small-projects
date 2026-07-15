import 'elirx.dart';

void main() {
  List<int> arr = [2, 3, 5, 6, 7, 8];
  var xor = 0;
  for (int i = arr.first; i <= arr.last; i++) {
    xor ^= i;
  }
  for (var ch in arr) {
    xor ^= ch;
  }
  print((xor));
}
