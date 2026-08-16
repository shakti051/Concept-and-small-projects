
void main(){
  // String str = "Flutter makes apps beautiful";
  // String result = str
  //     .split(" ")              // split into words
  //     .map((word) => word.split('').reversed.join('')) // reverse each word
  //     .join(' '); 

  // print(result);
  
  String str = "Flutter makes apps beautiful";
  List<String> words = str.split(" ");
  StringBuffer buffer = StringBuffer();
  for(String word in words){
      for (var i = word.length-1; i>=0; i--) {
      buffer.write(word[i]);      
      }      
      buffer.write(" ");
  }
  print(buffer.toString().trim());
}