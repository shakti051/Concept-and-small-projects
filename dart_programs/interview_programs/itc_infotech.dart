
void main() {
String? str =  firstNon("aabbcde");
print(str);
}

String? firstNon(String str){
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
