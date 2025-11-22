
void main(){
List<int> arr = [1, 1, 2, 2, 2, 3, 3];
 int k = removeDuplicate(arr);
 for(int i=0;i<k;i++){
  print(arr[i]);
 }
}

int removeDuplicate(List<int> arr){
 int i = 0;
  for(int j = 0;j<arr.length;j++)
  {
   if(arr[i]!=arr[j]){
    i++;
    arr[i]= arr[j];
   }
  }
 return i+1;
} 