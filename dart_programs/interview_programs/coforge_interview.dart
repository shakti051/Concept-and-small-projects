

void main() {
  String a = "piquancy";
  String b = "refocusing";
  Set<String> setA = {};
  Set<String> setB = {};

  for (var ch in a.split("")) {
    setA.add(ch);
  }

  for (var ch in b.split("")) {
    setB.add(ch);
  }
  Set<String> forbidden = {...setA};
  forbidden.retainAll(setB);
  if (forbidden.isEmpty) {
    print(a.length + b.length);
    return;
  }

  final combined = '$a$b$a';
  int current = 0;
  int maxLength = 0;

  for (var ch in combined.split("")) {
    if (forbidden.contains(ch)) {
      if (current > maxLength) {
        maxLength = current;
      }
      current = 0;
    } else
      current++;
  }

  if (current > maxLength) {
    maxLength = current;
  }
  print(maxLength);
}
