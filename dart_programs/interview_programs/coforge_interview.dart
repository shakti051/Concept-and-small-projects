//

void main() {
  List<int> arr = [3, 1, 2, 4];
  int k = 6;
  Map<int,int> freq = {0:1};
  int count = 0;
  int sum = 0;
  for (var num in arr) {
      sum+=num;
      int reminder = sum-k;
      if(freq.containsKey(reminder)){
        count+= freq[reminder]!;
      }   
      freq[sum]= (freq[sum] ?? 0)+1;
  }
  print(count);
}