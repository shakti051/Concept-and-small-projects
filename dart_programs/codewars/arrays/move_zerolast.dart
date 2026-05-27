

void main(){
var arr= [false,1,0,1,2,0,1,3,"a"];
int j =0;
for (var i = 0; i < arr.length; i++) {
  if(arr[i]!=0){
    var temp = arr[i];
    arr[i]=arr[j];
    arr[j]=temp;
    j++;
  }
}
print(arr);
}