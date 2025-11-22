
void main() {

  List<int> arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> arr2 = [2, 3, 4, 4, 5, 11, 12];
  Set<int> unionSet = {...arr1,...arr2};
  print("The union set is $unionSet"); 

}