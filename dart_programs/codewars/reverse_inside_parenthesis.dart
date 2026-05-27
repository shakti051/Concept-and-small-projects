class Solution {
  int index = 0;

  String reverseInParens(String s) {
    index = 0;
    return solve(s);
  }

  String solve(String s) {
    StringBuffer result = StringBuffer();

    while (index < s.length) {
      String ch = s[index];

      // Start nested section
      if (ch == '(') {
        index++;

        String inner = solve(s);

        // Reverse inner content
        StringBuffer rev = StringBuffer();

        for (int i = inner.length - 1; i >= 0; i--) {
          String c = inner[i];

          // Swap parentheses directions
          if (c == '(') {
            rev.write(')');
          } else if (c == ')') {
            rev.write('(');
          } else {
            rev.write(c);
          }
        }

        result.write('(');
        result.write(rev.toString());
        result.write(')');
      }

      // End current section
      else if (ch == ')') {
        return result.toString();
      }

      // Normal character
      else {
        result.write(ch);
      }

      index++;
    }

    return result.toString();
  }
}

void main() {
  Solution sol = Solution();

  print(sol.reverseInParens("h(el)lo"));
  // h(le)lo

  print(sol.reverseInParens("a ((d e) c b)"));
  // a (b c (d e))

  print(sol.reverseInParens("one (two (three) four)"));
  // one (ruof (three) owt)

  print(sol.reverseInParens("one (ruof ((rht)ee) owt)"));
  // one (two ((thr)ee) four)

  print(sol.reverseInParens("no parentheses"));
  // no parentheses
}
