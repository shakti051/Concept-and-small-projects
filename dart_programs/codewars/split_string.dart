// * 'abc' =>  ['ab', 'c_']
// * 'abcdef' => ['ab', 'cd', 'ef']

List<String> solution(String str) {
  List<String> result = [];
  if (str.length.isOdd) str += "_";
  for (int i = 0; i < str.length; i += 2) {
    result.add(str.substring(i, i + 2));
  }
  return result;
}

void main() {
  List<String> strList = solution("abcde");
  print(strList);
}
