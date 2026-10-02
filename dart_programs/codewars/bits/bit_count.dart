
// The binary representation of 
// 1234 is 10011010010, so the function should return 5 in this case

void main(){
  int n = 12345;
  int count = 0;
  while(n!=0){
    n = n & (n-1);//rightmost 1 bit removed
    count++;
  }
  print(count);
}

// Time Complexity  → O(k)
// Space Complexity → O(1)