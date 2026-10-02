
void main(){
int num = 10;
int sum = 0;
for (var i = 0; i < num; i++) {
  if(i %3==0 || i%5 ==0){
    sum+=i;
  }
}
print(sum);
}