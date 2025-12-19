import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/teacher.dart';
import 'add_teacher_screen.dart';
import 'edit_teacher_page.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  late Box<Teacher> teacherBox;
  
  @override
  void initState() {    
    super.initState();
    teacherBox = Hive.box('teachers');
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: teacherBox.listenable(), 
        builder: (context,box,child) {

        return ListView.builder(
          itemCount: teacherBox.length,
          itemBuilder: ((context, index) {
            final student = teacherBox.getAt(index) as Teacher;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => EditTeacherScreen(index: index)));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.id.toString()),
                      Text(student.name.toString()),
                      Text(student.age.toString()),
                      Text(student.subject.toString()),                      
                    ],
            
                  ),
                ),
              ),
            );

        }
        ),);     

        },
      ),       
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => const AddTeacherScreen(),));
        }, 
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}