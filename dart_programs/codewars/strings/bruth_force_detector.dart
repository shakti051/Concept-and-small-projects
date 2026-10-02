//https://www.codewars.com/kata/695688e9858d531c29a9d748/train/java

class BruteForceDetector {
  static List<String> detectBruteForce(List<String> logs) {
    // IP -> consecutive failure count
    final Map<String, int> failures = {};

    // Set prevents duplicate IPs
    final Set<String> suspicious = {};

    for (final log in logs) {
      final parts = log.split(' ');

      final ip = parts[0];
      final action = parts[1];

      if (action == 'LOGIN_FAIL') {
        final count = (failures[ip] ?? 0) + 1;

        failures[ip] = count;

        if (count >= 3) {
          suspicious.add(ip);
        }
      } else if (action == 'LOGIN_SUCCESS') {
        // Success resets this IP's failure streak.
        failures[ip] = 0;
      }
    }

    // Sort alphabetically.
    final result = suspicious.toList();
    result.sort();

    return result;
  }
}

void main() {
  final logs = [
    '192.168.1.1 LOGIN_FAIL user=admin',
    '192.168.1.1 LOGIN_FAIL user=admin',
    '192.168.1.1 LOGIN_FAIL user=root',
    '10.0.0.5 LOGIN_FAIL user=test',
    '10.0.0.5 LOGIN_SUCCESS user=test',
  ];

  print(BruteForceDetector.detectBruteForce(logs));
}