
void main() {
  List<Map<String, dynamic>> users = [
    {"id":1,"name":"A"},
    {"id":2,"name":"B"},
  ];

  Map<int, Map<String, dynamic>> userMap = {
    for (var user in users) user['id']: user
  };

  print(userMap);
}

