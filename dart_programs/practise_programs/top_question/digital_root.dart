//https://www.codewars.com/kata/541c8630095125aba6000c00/train/dart
// 16  -->  1 + 6 = 7
//    942  -->  9 + 4 + 2 = 15  -->  1 + 5 = 6
// 132189  -->  1 + 3 + 2 + 1 + 8 + 9 = 24  -->  2 + 4 = 6

int digitalRoot(int n) {
  while (n >= 10) {
    int sum = 0;

    while (n > 0) {
      sum += n % 10;
      n ~/= 10;
    }

    n = sum;
  }

  return n;
}

void main() {
  print(digitalRoot(16));     // 7
  print(digitalRoot(942));    // 6
  print(digitalRoot(132189)); // 6
  print(digitalRoot(493193)); // 2
}

int digitalRootOptimize(int n) {
  if (n == 0) return 0;
  return 1 + (n - 1) % 9;
}

//Time = O(log n) base 10
//Time Complexity: O(1)