
void main() {
  final data = {
    "id": 1,
    "name": "Root",
    "children": [
      {
        "id": 2,
        "name": "Group A",
        "children": [
          {
            "id": 3,
            "name": "Group A1",
            "children": [
              {
            "id": 5,
            "name": "Group A2",
            "children": []
          }
            ]
          }
        ]
      },
      {
        "id": 4,
        "name": "Group B",
        "children": []
      }
    ]
  };

  List<Map<String,dynamic>> result = [];
  flattenTree(data, result);

  print(result);
}

void flattenTree(
  Map<String, dynamic> node,
  List<Map<String, dynamic>> result,
) {
  // Add current node
  result.add({
    "id": node["id"],
    "name": node["name"],
  });

  // Process children recursively
  for (var child in node["children"]) {
    flattenTree(child, result);
  }
}