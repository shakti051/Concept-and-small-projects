
void main() {
  List<int> arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> arr2 = [2, 3, 4, 4, 5, 11, 12];
  int i = 0;
  int j = 0;
  List<int> merged = [];
  while (i < arr1.length && j < arr2.length) {
    if(arr1[i]<arr2[j]){
        merged.add(arr1[i++]);
    }else{
        merged.add(arr2[j++]);
    }
  }
    while(i<arr1.length)
    merged.add(arr1[i++]);
    while(j<arr2.length)
    merged.add(arr2[j++]);
  print(merged);
}
