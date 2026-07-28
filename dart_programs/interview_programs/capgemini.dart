import 'dart:io';

void main() {
  //  List<int> result = findDuplicate([1,2,3,3,4,4,5]);
  //  print(result);
  stdout.write("Enter numbers separated by comman: ");
  String? input = stdin.readLineSync();
  List<int> nums = input!.split(" ").map((e) => int.parse(e)).toList();
  var duplicate = findDuplicate(nums);
  print(duplicate);
}

List<int> findDuplicate(List nums) {
  var seen = <int>{};
  final duplicates = <int>{};
  for (var num in nums) {
    if (!seen.add(num)) {
      duplicates.add(num);
    }
  }
  return duplicates.toList();
}
