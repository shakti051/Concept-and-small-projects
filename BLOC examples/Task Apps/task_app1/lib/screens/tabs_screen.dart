import 'package:flutter/material.dart';
import 'package:task_app1/screens/completed_task_screen.dart';
import 'package:task_app1/screens/favorite_task_screen.dart';
import 'package:task_app1/screens/my_drawer.dart';
import 'package:task_app1/screens/pending_screen.dart';
import 'add_task_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  static const id = "tabs_screen";

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const PendingTaskScreen(), 'title': 'Pending Task'},
    {'pageName': const CompletedTaskScreen(), 'title': 'Completed Task'},
    {'pageName': const FavoriteTaskScreen(), 'title': 'Favorite Task'},
  ];

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTaskScreen(),
        ),
      ),
    );
  }

  var _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageDetails[_selectedPageIndex]["title"]),
        actions: [
          IconButton(
            onPressed: () {
              _addTask(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: _pageDetails[_selectedPageIndex]["pageName"],
      floatingActionButton: _selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Pending Task",
            icon: Icon(Icons.incomplete_circle_sharp),
          ),
          BottomNavigationBarItem(
            label: "Completed Task",
            icon: Icon(Icons.done),
          ),
          BottomNavigationBarItem(
            label: "Favorite Task",
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}
