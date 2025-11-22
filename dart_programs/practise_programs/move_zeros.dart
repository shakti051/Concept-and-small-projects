

void main(){
List<int> arr = [1, 0, 2, 3, 2, 0, 0, 4, 5, 1];
int j =0;
 for(int i=0;i<arr.length;i++)
 {
   if(arr[i]!=0){
    int temp = arr[i];
    arr[i]=arr[j];
    arr[j]=temp;
    j++;
   }
 }
 print("The required array is $arr");

}