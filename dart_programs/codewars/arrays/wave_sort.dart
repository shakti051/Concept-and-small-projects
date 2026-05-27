
import '../../practise_programs/sort_zero_one_two.dart';

void main(){
  List<int> arr = [10, 90, 49, 2, 1, 5, 23];

  for (var i = 0; i < arr.length-1; i++) {
    if(i%2==0){
      if(arr[i]<arr[i+1]){
        swap(arr, i, i+1);
      }
    }else{
      if(arr[i]>arr[i+1]){
        swap(arr, i, i+1);
      }
    }
  }
print(arr);
}

