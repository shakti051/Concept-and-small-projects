import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    required this.text,
    required this.ontap,
    this.isLoading = false,
    super.key,
  });

  final Function ontap;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            isLoading ? const CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }
}
