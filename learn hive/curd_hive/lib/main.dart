import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('usersBox'); // no adapter

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  int? editingKey; // Hive key

void saveUser() async {
  if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty) return;

  final box = Hive.box('usersBox');

  final user = User(
    name: nameCtrl.text,
    email: emailCtrl.text,
  );

  if (editingKey == null) {
    // ADD
    await box.add(user.toMap());
  } else {
    // UPDATE
    await box.put(editingKey, user.toMap());

    // 👇 IMPORTANT: exit edit mode after update
    editingKey = null;
  }

  clearForm();
}

void clearForm() {
  setState(() {
    editingKey = null; // 👈 forces button back to "Add User"
    nameCtrl.clear();
    emailCtrl.clear();
  });
}


  void editUser(int key, Map data) {
    final user = User.fromMap(data);

    setState(() {
      editingKey = key;
      nameCtrl.text = user.name;
      emailCtrl.text = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('usersBox');

    return Scaffold(
      appBar: AppBar(title: const Text('Hive CRUD (No Adapter)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORM
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: saveUser,
              child: Text(editingKey == null ? 'Add User' : 'Update User'),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No users'));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (_, index) {
                      final key = box.keyAt(index);
                      final data = box.get(key) as Map;
                      final user = User.fromMap(data);

                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        leading: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editUser(key, data),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => box.delete(key),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
