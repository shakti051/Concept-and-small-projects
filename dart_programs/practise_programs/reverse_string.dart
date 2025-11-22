
void main(){
  String str= "My name is Vikas";
  List<String> words = str.split(" ");
  String result = "";
  for(int i = words.length-1;i>=0;i--){
    result += words[i] +" ";
  }
  print(result.trim());
}