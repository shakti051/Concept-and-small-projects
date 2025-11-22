
void main(){
 List<int> arr = [8, 7, 2, 5, 3, 1];
  int k = 10;

  List<int> result = pairWithSumIndices(arr, k); 
  print(result);
}

List<int> pairWithSumIndices(arr, k){
 Map<int,int> map = {};
 
 for(int i=0;i<arr.length;i++){
    int complement = k-arr[i];

    if(map.containsKey(complement)){
      int j = map[complement]!;
      return [j,i];
    }
    map[arr[i]]=i;   
 }
 return [-1,-1];
}