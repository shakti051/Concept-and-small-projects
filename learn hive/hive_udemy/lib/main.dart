import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_udemy/model/student.dart';
import 'package:hive_udemy/page/home_page.dart';
import 'model/bank.dart';
import 'model/teacher.dart';
import 'page/bank_dart.dart';
import 'page/student_page.dart';
import 'page/teacher_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();


  String? encryptionKey = await secureStorage.read(key: 'hiveKey');
  if (encryptionKey == null) {
    final key  = Hive.generateSecureKey();
    encryptionKey = base64Url.encode(key);
    await secureStorage.write(key: 'hiveKey', value:encryptionKey);
  }
  
  final key  = base64Url.decode(encryptionKey);



  Hive.registerAdapter<Student>(StudentAdapter());
  Hive.registerAdapter<Teacher>(TeacherAdapter());  
  Hive.registerAdapter<Bank>(BankAdapter());
  
  
  await Hive.openBox('home');
  await Hive.openBox<Student>('students');
  await Hive.openBox<Teacher>(
    'teachers',
    compactionStrategy: ((entries, deletedEntries) => deletedEntries >= 20));
  await Hive.openBox<Bank>('banks', encryptionCipher: HiveAesCipher(key));


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final pages = [
    const HomePage(),
    const StudentScreen(),
    const TeacherScreen(),
    const BankScreen(),
  ];

  @override
  void dispose() {
    Hive.box('home').compact();
    Hive.close();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(      
        title:const Text("Flutter Hive")
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.tealAccent,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Student'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Teacher'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Bank'
          )
        ],
      ),
    );
  }
}