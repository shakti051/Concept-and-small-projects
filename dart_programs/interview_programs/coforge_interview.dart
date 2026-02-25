
void main(){
  List<int> arr = [2,6,7,3,9,11,5];
  int max = -1 << 31;
  int second = -1 << 31;
  for (var num in arr) {
    if(num>max){
        second=max;
        max=num;
    }else if(num>second && num!=max)
    second=num;
  }
  print(second);
}