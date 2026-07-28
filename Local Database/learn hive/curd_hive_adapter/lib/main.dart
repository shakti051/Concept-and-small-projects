import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/user.dart';
import 'screens/home_page.dart';
//flutter pub run build_runner build --delete-conflicting-outputs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive CRUD',
      home: HomePage(),
    );
  }
}
