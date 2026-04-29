
void main() {
  List<int> arr = [-1, 1, 1];
  int k=1;
  int sum=0;

  Map<int,int> map = {};
  int maxLen =0;
  int startIndex = -1;
  int endIndex = -1;  

  for (var i = 0; i < arr.length; i++) {
    sum+=arr[i];
    if(sum==k){
      if(i+1>maxLen){
        maxLen=i+1;
        startIndex =0;
        endIndex = i;              
      }
    }
    int reminder = sum -k;
    if(map.containsKey(reminder)){
      int len = i - map[reminder]!;
      if(len>maxLen){
        maxLen=len;
        startIndex = map[reminder]!+1;
        endIndex = i;
      }
    }else{
      map[sum] = i;
    }
  }
  print(maxLen);
  for (var i = startIndex; i <= endIndex; i++) {
    print(arr[i].toString()+",index $i");
  }
}
