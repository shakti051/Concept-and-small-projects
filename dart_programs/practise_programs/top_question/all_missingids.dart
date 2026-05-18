
void main() {
List<int> ids = [1, 2, 4, 5, 7];
Set<int> idSet = ids.toSet();
  List<int> missing = [];
  for (var i = ids.first; i <= ids.last; i++) {
    if(!idSet.contains(i)){
        missing.add(i);
    }
  }
  print(missing);
}
