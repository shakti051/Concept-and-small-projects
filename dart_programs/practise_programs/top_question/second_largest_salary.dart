
void main() {
  List<Map<String, dynamic>> employees = [
    {"name": "A", "salary": 40000},
    {"name": "B", "salary": 70000},
    {"name": "C", "salary": 50000},
    {"name": "D", "salary": 60000},
  ];

  int largest = -1;
  int secondLargest = -1;

  for (var emp in employees) {
    int salary = emp["salary"];

    if (salary > largest) {
      secondLargest = largest;
      largest = salary;
    } else if (salary > secondLargest &&
        salary != largest) {
      secondLargest = salary;
    }
  }

  print("Largest: $largest");
  print("Second Largest: $secondLargest");
}