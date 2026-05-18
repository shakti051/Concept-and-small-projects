
void main() {
  List<Map<String, dynamic>> students = [
    {
      "name": "A",
      "scores": [50, 80, 90]
    },
    {
      "name": "B",
      "scores": [95, 70]
    }
  ];

  int maxScore = 0;

  for (var student in students) {

    List<dynamic> scores = student["scores"];

    for (var score in scores) {

      if (score > maxScore) {
        maxScore = score;
      }
    }
  }

  print(maxScore);
}