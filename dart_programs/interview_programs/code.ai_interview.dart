//Reverse a number 

void main() {
  int num = 75;
  int tempNum = num;
  int revesed = 0;
  while(tempNum>0){
    int lastDigit = tempNum%10;
     revesed = revesed*10 +lastDigit;//5//50+7
     tempNum ~/=10;
  }
print(revesed);
}
