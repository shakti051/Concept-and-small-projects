
void main() {
String? str =  firstNon("aabbcde");
print(str);
}
//
String? firstNon(String str){
// List<int> freq = List.filled(26, 0);
// for (var codeUnit in str.codeUnits ) {
//       freq[codeUnit - 97]++;
// }

// for (final code in str.codeUnits) {
//     if (freq[code - 97] == 1) {
//       return String.fromCharCode(code);
//     }
//   }

 Map<String,int> map = {};
for (var ch in str.split("")) {
  map[ch]=(map[ch]?? 0)+1;
}

for (var ch in str.split("")) {
  if(map[ch]==1){
    //print(ch);
    return ch;
  }
} 
return null;
}
