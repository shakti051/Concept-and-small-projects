
String rearrangeString(String str, List<int> indices) {
List<String> result = List.filled(str.length, '');
for (var i = 0; i < str.length; i++) {
  result[indices[i]]= str[i];
  
}
return result.join();
}

 void main() {
  print(rearrangeString("abcd", [0, 3, 1, 2])); // acdb
} // 108

