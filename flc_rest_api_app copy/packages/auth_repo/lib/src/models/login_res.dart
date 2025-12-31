
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

LoginRes loginResFromJson(String str) => LoginRes.fromJson(json.decode(str));

String loginResToJson(LoginRes data) => json.encode(data.toJson());

class LoginRes {
  String email;
  String password;
  String accessToken;

  LoginRes({
    required this.email,
    required this.password,
    required this.accessToken,
  });

  factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        email: json["email"],
        password: json["password"],
        accessToken: json["accessToken"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "accessToken": accessToken,
      };
}
