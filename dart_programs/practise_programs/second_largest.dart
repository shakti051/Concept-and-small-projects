
void main(){
  List<int> arr = [1, 2, 4, 7, 7, 5];
  int largest = -1;
  int second = -1;

  for (int num in arr) {
    if(num>largest){
      second = largest;
      largest = num;
    }else if(num>second && num!=largest){
        second = num;
    }    
  }
  print("The second largest number is $second");    
}
