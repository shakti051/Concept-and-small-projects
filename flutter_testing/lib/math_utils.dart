int add(int a, int b) {
  return a + b;
}

int substract(int a, int b) {
  return a - b;
}

int multipy(int a, int b) {
  return a * b;
}

int divide(int a, int b) {
  if (b == 0) {
    throw Exception("Cannot divide by zero");
  }
  return a ~/ b;
}
