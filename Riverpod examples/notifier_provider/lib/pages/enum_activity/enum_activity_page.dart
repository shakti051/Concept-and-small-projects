import 'dart:math';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity.dart';
import 'enum_activity_provider.dart';
import 'enum_activity_state.dart';

class EnumActivityPage extends ConsumerStatefulWidget {
  const EnumActivityPage({super.key});

  @override
  ConsumerState<EnumActivityPage> createState() =>
      _EnumActivityPageState();
}

class _EnumActivityPageState extends ConsumerState<EnumActivityPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(enumActivityProvider.notifier)
          .fetchActivity(activityTypes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EnumActivityState>(
      enumActivityProvider,
      (previous, next) {//
        if (next.status == ActivityStatus.failure) {
          debugPrint('API Error: ${next.error}');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('API Error'),
                content: Text(next.error),
              );
            },
          );
        }
      },
    );

    final activityState = ref.watch(enumActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EnumActivityNotifier'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(myCounterProvider.notifier).increment();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(enumActivityProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (activityState.status) {
        ActivityStatus.initial => const Center(
            child: Text(
              'Get some activity',
              style: TextStyle(fontSize: 20),
            ),
          ),

        ActivityStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),

        ActivityStatus.failure => _buildFailureWidget(activityState),

        ActivityStatus.success => activityState.activities.isEmpty
            ? const Center(
                child: Text('No activities found'),
              )
            : ActivityWidget(
                activity: activityState.activities.first,
              ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final randomNumber = Random().nextInt(activityTypes.length);
          ref
              .read(enumActivityProvider.notifier)
              .fetchActivity(activityTypes[randomNumber]);
        },
        label: Text(
          'New Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildFailureWidget(EnumActivityState activityState) {
    debugPrint('API Error: ${activityState.error}');

    return activityState.activities.isEmpty
        ? Center(
            child: Text(
              activityState.error,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          )
        : ActivityWidget(
            activity: activityState.activities.first,
          );
  }
}

class ActivityWidget extends StatelessWidget {
  final Activity activity;

  const ActivityWidget({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        Text(
          activity.type,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Divider(),
        BulletedList(
          bullet: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          listItems: [
            'activity: ${activity.activity}',
            'availability: ${activity.availability}',
            'participants: ${activity.participants}',
            'price: ${activity.price}',
            'accessibility: ${activity.accessibility}',
            'duration: ${activity.duration}',
            'link: ${activity.link.isEmpty ? 'no link' : activity.link}',
            'kidFriendly: ${activity.kidFriendly}',
            'key: ${activity.key}',
          ],
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
