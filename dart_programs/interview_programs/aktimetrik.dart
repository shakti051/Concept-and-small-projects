
void main() {
int num = 537;
int sum = 0; 
while(num>0){
  sum+=num%10;
  num~/=10;
}

print(sum);
// List<int> arr = [2,4,3,7,9,1];
// int largest =  -1 << 31;
// int second =  -1 << 31;
// for (var num in arr) {
//   if(num>largest){
//     second=largest;
//     largest=num;
//   }else if(num> second && num!=largest){
//     second = num;
//   }
// }
// print(second);
}


