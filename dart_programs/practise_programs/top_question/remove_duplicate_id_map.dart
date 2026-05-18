
void main() {
  List<Map<String, dynamic>> arr = [
    {"id": 1, "name": "A"},
    {"id": 1, "name": "A"},
    {"id": 2, "name": "B"},
  ];
  Set<int> idSeens = {};
  List<Map<String, dynamic>> unique = [];
  //  unique = arr.where((item){
  //   return idSeens.add(item["id"]);
  //  }).toList();
    for (var item in arr) {
    if (!idSeens.contains(item["id"])) {
      idSeens.add(item["id"]);
      unique.add(item);
    }
  }
print(unique);
}

