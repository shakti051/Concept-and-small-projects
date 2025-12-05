

void main(){
  String str = "Flutter makes apps beautiful";
  String result = str
      .split(" ")              // split into words
      .map((word) => word.split('').reversed.join('')) // reverse each word
      .join(' '); 

  print(result);
}