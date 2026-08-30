

void main() {
  final field = [
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
  ];

  print(mineLocation(field));
}

List<int> mineLocation(List<List<int>> field) {
  for (int row = 0; row < field.length; row++) {
    for (int col = 0; col < field[row].length; col++) {
      if (field[row][col] == 1) {
        return [row, col];
      }
    }
  }

  return [];
}