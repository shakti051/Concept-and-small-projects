import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<User> userBox = Hive.box<User>('users');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  int? editingIndex;

  void addUser() {
    userBox.add(
      User(
        name: nameController.text.trim(),
        age: int.parse(ageController.text.trim()),
      ),
    );
    clearForm();
    setState(() {});
  }

  void updateUser() {
    if (editingIndex == null) return;

    final user = userBox.getAt(editingIndex!);
    if (user != null) {
      user.name = nameController.text.trim();
      user.age = int.parse(ageController.text.trim());
      user.save(); // ✅ IMPORTANT
    }

    clearForm();
    editingIndex = null;
    Navigator.pop(context);
    setState(() {});
  }

  void clearForm() {
    nameController.clear();
    ageController.clear();
  }

  void openEditDialog(int index) {
    final user = userBox.getAt(index)!;

    nameController.text = user.name;
    ageController.text = user.age.toString();
    editingIndex = index;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: updateUser,
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive CRUD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addUser,
                  child: const Text('Add User'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: userBox.length,
              itemBuilder: (_, index) {
                final user = userBox.getAt(index)!;
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age: ${user.age}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openEditDialog(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          userBox.deleteAt(index);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}