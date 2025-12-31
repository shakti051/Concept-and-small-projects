
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Creds credsFromJson(String str) => Creds.fromJson(json.decode(str));

String credsToJson(Creds data) => json.encode(data.toJson());

class Creds {
  String email;
  String password;

  Creds({
    required this.email,
    required this.password,
  });

  factory Creds.fromJson(Map<String, dynamic> json) => Creds(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
