
void main() {
List<String> ids = ['A', 'B', 'C', 'E', 'G'];;
  List<String> missing = [];
  for (int i= ids.first.codeUnitAt(0); i<= ids.last.codeUnitAt(0);i++) {
    if(!ids.contains(String.fromCharCode(i))){
        missing.add(String.fromCharCode(i));
    }
  }
  print(missing);
}