import 'package:flutter/material.dart';
import 'package:notifications_repo/notifications_repo.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
    this.not, {
    super.key,
  });
  final NotificationDetails not;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            not.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            not.description,
            style: const TextStyle(
              color: Color.fromARGB(255, 222, 222, 222),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
