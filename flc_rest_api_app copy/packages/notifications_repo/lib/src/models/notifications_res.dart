
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<NotificationDetails> notificationResFromJson(String str) =>
    List<NotificationDetails>.from(
        json.decode(str).map((x) => NotificationDetails.fromJson(x)));

String notificationResToJson(List<NotificationDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationDetails {
  String title;
  String description;

  NotificationDetails({
    required this.title,
    required this.description,
  });

  factory NotificationDetails.fromJson(Map<String, dynamic> json) =>
      NotificationDetails(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
