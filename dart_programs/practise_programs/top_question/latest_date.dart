
void main() {
  List<Map<String, dynamic>> data = [
    {"date": "2025-01-01"},
    {"date": "2026-03-01"},
    {"date": "2024-08-01"},
  ];

  Map<String, dynamic> latest = data.first;

  for (var item in data) {
    DateTime currentDate = DateTime.parse(item["date"]);
    DateTime latestDate = DateTime.parse(latest["date"]);
    if (currentDate.isAfter(latestDate)) {
      latest = item;
    }
  }
  print(latest);
}
