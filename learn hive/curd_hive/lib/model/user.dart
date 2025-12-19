
class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  // Convert User → Map (for Hive)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Convert Map → User
  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
    );
  }
}
