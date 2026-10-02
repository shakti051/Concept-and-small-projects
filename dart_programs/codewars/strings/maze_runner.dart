//https://www.codewars.com/kata/58663693b359c4a6560001d6

class MazeRunner {
  static String walk(List<List<int>> maze, List<String> directions) {
    int row = 0;
    int col = 0;

    // Find the starting position (2)
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        if (maze[i][j] == 2) {
          row = i;
          col = j;
        }
      }
    }

    // Follow the directions
    for (final direction in directions) {
      switch (direction) {
        case 'N':
          row--;
          break;

        case 'S':
          row++;
          break;

        case 'E':
          col++;
          break;

        case 'W':
          col--;
          break;
      }

      // Outside the maze
      if (row < 0 ||
          row >= maze.length ||
          col < 0 ||
          col >= maze[0].length) {
        return 'Dead';
      }

      // Hit a wall
      if (maze[row][col] == 1) {
        return 'Dead';
      }

      // Reached finish
      if (maze[row][col] == 3) {
        return 'Finish';
      }
    }

    // Still inside the maze after all moves
    return 'Lost';
  }
}

void main() {
  final maze = [
    [1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 3],
    [1, 0, 1, 0, 1, 0, 1],
    [0, 0, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1],
    [1, 2, 1, 0, 1, 0, 1],
  ];

  final directions = [
    'N',
    'N',
    'N',
    'N',
    'N',
    'E',
    'E',
    'E',
    'E',
    'E',
  ];

  print(MazeRunner.walk(maze, directions));
}