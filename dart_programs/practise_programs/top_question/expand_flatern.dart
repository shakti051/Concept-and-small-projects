import 'dart:math';

void main() {
  List<List<int>> list = [
    [1, 2],
    [3, 4],
  ];
  List<int> result = list.expand((row)=>row).toList();
  // List<int> result = [];
  // for (var row in list) {
  //   for (var value in row) {
  //     result.add(value);
  //   }
  // }
   print(result);
}
