
void main(){
 List<int> arr = [10, 5, 10, 15, 10, 5];
 
  //**Count freq of each element**//  
 Map<int,int> freqMap = {};

 for (int num in arr) 
 {
   freqMap[num] = (freqMap[num]?? 0)+1;
 }

  //* Step 2: Initialize variables
  int? maxEle;
  int? minEle;
  int maxFreq = 0;
  int minFreq = arr.length;//* start with maxium possible value

 freqMap.forEach((key,value){
   if(value >maxFreq)
   {
    maxFreq = value;
    maxEle = key;
   }

   if(value < minFreq)
   {
    minFreq = value;
    minEle = key;
   }

 });
  
  //**/ Step 4: Print results
  print("Frequencies $freqMap");
  print("Max freq element $maxEle , $maxFreq times");
  print("Min freq element $minEle , $minFreq times");
}