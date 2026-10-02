//https://www.codewars.com/kata/56bdd0aec5dc03d7780010a5/dart

// Input: 129    => Output: 130    (10000001 => 10000010)
// Input: 127    => Output: 191    (01111111 => 10111111)
// Input: 1      => Output: 2      (01 => 10)
// Input: 323423 => Output: 323439 (1001110111101011111 => 1001110111101101111)

int nextHigher(int n) {
  int c = n & -n;
  int r = c + n;
  int once = ((r ^ n) >> 2) ~/ c;
  return r | once;
}

void main(){
  print(nextHigher(323423));
}

// Time:  O(1)
// Space: O(1)