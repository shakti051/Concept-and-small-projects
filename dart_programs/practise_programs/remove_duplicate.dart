//
void main(){
List<int> arr = [1, 1, 2, 2, 2, 3, 3];
 int k = removeDuplicate(arr);
//
 for(int i=0;i<k;i++){
  print(arr[i]);
 }
}

int removeDuplicate(List<int> arr){
 int j = 0;
  for(int i = 0;i<arr.length;i++)
  {
   if(arr[i]!=arr[j]){
    j++;
    arr[j]= arr[i];
   }
  }
 return j+1;
} 

