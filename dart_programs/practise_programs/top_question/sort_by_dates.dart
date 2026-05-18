
void main() {
  List<Map<String, dynamic>> data = [
    {"date": "2026-01-01"},
    {"date": "2025-05-01"},
  ];

  data.sort((a, b) {
    DateTime dateA = DateTime.parse(a["date"]);
    DateTime dateB = DateTime.parse(b["date"]);

    return dateA.compareTo(dateB);
  });

  print(data);
}