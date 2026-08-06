
class HiveBoxes {
  static String tasks(String email) {
    final normalizedEmail = email.trim().toLowerCase();

    // Make the email safe for a Hive box name.
    final safeEmail = normalizedEmail.replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),
      '_',
    );

    return 'tasks_$safeEmail';
  }
}