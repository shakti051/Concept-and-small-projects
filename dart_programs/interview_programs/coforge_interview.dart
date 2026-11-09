//
import 'dart:math';

void main() {
  List<int> arr = [100, 200, 1, 2, 5, 3, 4];
  int longest = 0;
  Set<int> integerSet = arr.toSet();
  List<int> longestSequence = [];

  for (var num in integerSet) {
        if(!integerSet.contains(num-1)){
          int x = num;
          int count = 1;
          List<int> currentSequence = [num];
          while(integerSet.contains(x+1)){
            x++;
            count++;  
            currentSequence.add(x);
          }//
          //longest = max(longest, count); 
          if(count>longest){
            longest =count;
            longestSequence = currentSequence;
          }
        }
  }
  //
  print("Longest $longest");
  print("List $longestSequence");    
}
