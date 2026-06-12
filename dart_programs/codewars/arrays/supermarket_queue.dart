//https://www.codewars.com/kata/57b06f90e298a7b53d000a86/solutions/java?filter=me&sort=best_practice&invalids=false
import 'dart:math';

int queueTime(List<int> customers, int n) {
  List<int> tills = List.filled(n, 0);

  for (int customer in customers) {
    // Find till with minimum workload
    int minIndex = 0;

    for (int i = 1; i < n; i++) {
      if (tills[i] < tills[minIndex]) {
        minIndex = i;
      }
    }
    
    // Assign customer to that till
    tills[minIndex] += customer;
  }
  // Return maximum workload
  return tills.reduce(max);
}


void main() {
  print(queueTime([5, 3, 4], 1));      // 12
  print(queueTime([10, 2, 3, 3], 2));  // 10
  print(queueTime([2, 3, 10], 2));     // 12
}