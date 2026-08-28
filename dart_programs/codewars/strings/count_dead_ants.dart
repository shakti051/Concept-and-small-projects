// An orderly trail of ants is marching across the park picnic area.
// It looks something like this:
// ..ant..ant.ant...ant.ant..ant.ant....ant..ant.ant.ant...ant..
// But suddenly there is a rumour that a dropped chicken sandwich has been spotted on the ground ahead. The ants surge forward! Oh No, it's an ant stampede!!
// Some of the slower ants are trampled, and their poor little ant bodies are broken up into scattered bits.
// The resulting carnage looks like this:
// ...ant...ant..nat.ant.t..ant...ant..ant..ant.anant..t
// Can you find how many ants have died?

void main() {
  const ants = '...ant...ant..nat.ant.t..ant...ant..ant..ant.anant..t';

  print(deadAntCount(ants)); // 3
}

int deadAntCount(String ants) {
  if (ants.isEmpty) {
    return 0;
  }

  int aCount = 0;
  int nCount = 0;
  int tCount = 0;

  // Count all pieces of ants.
  for (final ch in ants.split('')) {
    if (ch == 'a') {
      aCount++;
    } else if (ch == 'n') {
      nCount++;
    } else if (ch == 't') {
      tCount++;
    }
  }

  // The original number of ants is the largest count
  // among a, n and t.
  final totalAnts = [
    aCount,
    nCount,
    tCount,
  ].reduce((a, b) => a > b ? a : b);

  // Count complete surviving "ant" sequences.
  int survivingAnts = 0;

  for (int i = 0; i <= ants.length - 3; i++) {
    if (ants[i] == 'a' &&
        ants[i + 1] == 'n' &&
        ants[i + 2] == 't') {
      survivingAnts++;
      i += 2;
    }
  }

  return totalAnts - survivingAnts;
}