
 void main() {
  String result = firstNonRepeatingLetter("stress");   // "t"
  print(result);
} 

String firstNonRepeatingLetter(String str){
 Map<String,int> map = {};
 for (var i = 0; i < str.length; i++) {
   String ch = str[i];
   map[ch]=(map[ch]?? 0)+1;
 } 
 for (var i = 0; i < str.length; i++) {
   if(map[str[i]]==1){
    return str[i];
   }
 }
  return "";
}
