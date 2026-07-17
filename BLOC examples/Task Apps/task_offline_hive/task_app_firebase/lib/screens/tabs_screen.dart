import 'package:flutter/material.dart';
import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'completed_tasks_screen.dart';
import 'favorite_tasks_screen.dart';
import 'my_drawer.dart';
import 'pending_screen.dart';
import 'add_task_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const PendingTasksScreen(), 'title': 'Pending Tasks'},
    {'pageName': const CompletedTasksScreen(), 'title': 'Completed Tasks'},
    {'pageName': const FavoriteTasksScreen(), 'title': 'Favorite Tasks'},
  ];

  var _selectedPageIndex = 0;
  late final AnimationController _syncController;

  @override
  void initState() {
    super.initState();

    context.read<TasksBloc>().add(GetAllTsak());

    _syncController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _syncController.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const AddTaskScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listenWhen: (previous, current) =>
          previous.syncState != current.syncState,
      listener: (context, state) {
        switch (state.syncState) {
          case SyncState.synced:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.syncMessage ?? "Sync completed"),
                backgroundColor: Colors.green,
              ),
            );
            break;

          case SyncState.failed:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.syncMessage ?? "Sync failed. Will retry automatically.",
                ),
                backgroundColor: Colors.red,
              ),
            );
            break;

          case SyncState.syncing:
          case SyncState.idle:
            break;
        }
      },
      builder: (context, state) {
        final isSyncing = state.syncState == SyncState.syncing;

        if (isSyncing) {
          if (!_syncController.isAnimating) {
            _syncController.repeat();
          }
        } else {
          if (_syncController.isAnimating) {
            _syncController.stop();
            _syncController.reset();
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(_pageDetails[_selectedPageIndex]['title']),
            actions: [
              IconButton(
                tooltip: "Sync",
                onPressed: isSyncing
                    ? null
                    : () {
                        context.read<TasksBloc>().add(SyncPendingTasks(isManual: true));
                      },
                icon: RotationTransition(
                  turns: _syncController,
                  child: const Icon(Icons.sync),
                ),
              ),
              IconButton(
                onPressed: () => _addTask(context),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          drawer: const MyDrawer(),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_selectedPageIndex),
              child: _pageDetails[_selectedPageIndex]['pageName'],
            ),
          ),
          floatingActionButton: AnimatedScale(
            scale: _selectedPageIndex == 0 ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: _selectedPageIndex == 0
                ? FloatingActionButton(
                    onPressed: () => _addTask(context),
                    tooltip: 'Add Task',
                    child: const Icon(Icons.add),
                  )
                : const SizedBox.shrink(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPageIndex,
            onTap: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.incomplete_circle_sharp),
                label: 'Pending Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: 'Completed Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite Tasks',
              ),
            ],
          ),
        );
      },
    );
  }
}
