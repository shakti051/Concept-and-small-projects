// Given a string, replace:
//   🔵 'A' → 'B'
//   🟢 'Z' → 'A'
//
// ⚠️ EXCEPTION:
// In a sequence of consecutive 'A's, the FIRST 'A' must remain unchanged.
//
// 💡 This is a string manipulation / pattern replacement problem.

void main() {
  String str = "AAZZAABC";
  final result = StringBuffer();
  bool isPreviousA = false;

  for (var ch in str.split("")) {
    if (ch == "A") {
      if (isPreviousA) {
        result.write("B");
      } else {
        result.write("A");
      }
      isPreviousA = true;
    } else if (ch == "Z") {
      result.write("A");
      isPreviousA = false;
    } else {
      result.write("ch");
      isPreviousA = false;
    }
  }
  print(result.toString());
}

// Time Complexity  → O(n)
// Space Complexity → O(n)