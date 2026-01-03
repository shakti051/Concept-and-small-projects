import 'package:flutter/material.dart';
import '../../add_pages/add_task_page.dart';

class FAB extends StatelessWidget {
  const FAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (cxt) => const AddTaskPage(),
        ),
      ),
      child: const Icon(Icons.add),
    );
  }
}
