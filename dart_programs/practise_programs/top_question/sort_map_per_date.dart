

// void main() {
//   Map<String, String> data = {
//     "A": "2026-05-10",
//     "B": "2026-01-15",
//     "C": "2025-12-01",
//   };

//   // Sort by date ascending
//   var sortedEntries = data.entries.toList()
//     ..sort((a, b) =>
//         DateTime.parse(a.value).compareTo(DateTime.parse(b.value)));

//   // Convert back to map
//   Map<String, String> sortedMap = {
//     for (var entry in sortedEntries) entry.key: entry.value
//   };

//   print(sortedMap);
// }
void main() {
  
List<Map<String, dynamic>> users = [
  {"name": "A", "date": "2026-05-10"},
  {"name": "B", "date": "2025-01-01"},
];
users.sort((a,b){
  DateTime a1 = DateTime.parse(a["date"]);
  DateTime b1 = DateTime.parse(b["date"]);
  return a1.compareTo(b1);
});

print(users);
}