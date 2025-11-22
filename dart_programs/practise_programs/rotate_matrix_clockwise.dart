
void rotateMatrix90Clockwise(List<List<int>> matrix) {
  int n = matrix.length;

  // Step 1: Transpose the matrix
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      int temp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = temp;
    }
  }

  // Step 2: Reverse each row
  for (int i = 0; i < n; i++) {
    matrix[i].reverse();
  }
}

extension ReverseList on List<int> {
  void reverse() {
    int start = 0;
    int end = this.length - 1;

    while (start < end) {
      int temp = this[start];
      this[start] = this[end];
      this[end] = temp;
      start++;
      end--;
    }
  }
}


void printMatrix(List<List<int>> matrix) {
  for (var row in matrix) {
    print(row);
  }
}

void main() {
  List<List<int>> matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ];

  print("Original Matrix:");
  printMatrix(matrix);

  rotateMatrix90Clockwise(matrix);

  print("\nMatrix after 90° Clockwise Rotation:");
  printMatrix(matrix);
}
