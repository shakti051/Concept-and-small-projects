import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_bignner/providers/counter_async_notifier_provider.dart';
import 'package:riverpod_bignner/providers/counter_notifier_provider.dart';
import 'package:riverpod_bignner/screens/user_screen.dart';
import '../providers/counter_state_provider.dart';

class Counter extends ConsumerStatefulWidget {
  const Counter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CounterState();
}

class _CounterState extends ConsumerState<Counter> {
  //int counter = 0;
  @override
  Widget build(BuildContext context) {
    //final counter = ref.watch(counterStateProvider);
    // final counter = ref.watch(counterNotifierProvider);
    final counterAsyn = ref.watch(counterAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Counter Screen")),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () {
              //ref.read(counterStateProvider.notifier).state++;
              // ref.read(counterNotifierProvider.notifier).increment();
              ref.read(counterAsyncNotifierProvider.notifier).increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),

          const SizedBox(width: 10),

          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () {
              //ref.read(counterStateProvider.notifier).state--;
              ref.read(counterAsyncNotifierProvider.notifier).decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.minimize),
          ),

          const SizedBox(width: 10),

          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () {
              //ref.read(counterStateProvider.notifier).state--;
              ref.read(counterAsyncNotifierProvider.notifier).reset();
            },
            tooltip: 'Reset',
            child: const Icon(Icons.restore),
          ),
        ],
      ),
      body: Column(
        children: [
          counterAsyn.when(
            data: (data) =>
                Text('You have pushed the button this many times: $data'),
            error: (error, stackTrace) => Text('$error'),
            loading: () => const CircularProgressIndicator(),
          ),
          //Text('$counter')
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserScreen()),
              );
            }, 
            child: const Text('User'),
          )
        ],
      ),
    );
  }
}
