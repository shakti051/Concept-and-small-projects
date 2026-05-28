
void main(){
List<int> arr = [1,3,4,6]; 
int k = 9;
var result = twoSum(arr: arr,k: k);
print(result);
}

List<int> twoSum({required List<int> arr,required int k }){
Map<int,int> map = {};
for (var i = 0; i < arr.length; i++) {
  int num = arr[i];
  int reminder = k - num;
  if(map.containsKey(reminder)){
   // print("${map[reminder]!}, $i");
  return [map[reminder]!,i];
  }else{
    map[num]=i;
  }
}
return [-1,-1];
}