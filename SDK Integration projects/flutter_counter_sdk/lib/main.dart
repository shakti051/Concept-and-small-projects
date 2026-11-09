import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/counter_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Kotlin SDK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final CounterService _counterService = CounterService();

  int count = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  Future<void> loadCount() async {
    try {
      final result = await _counterService.getCount();

      if (!mounted) return;

      setState(() {
        count = result;
      });
    } on PlatformException catch (e) {
      debugPrint('Kotlin error: ${e.message}');
    }
  }

  Future<void> increment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _counterService.increment();

      if (!mounted) return;

      setState(() {
        count = result;
      });
    } on PlatformException catch (e) {
      debugPrint('Kotlin error: ${e.message}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> decrement() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _counterService.decrement();

      if (!mounted) return;

      setState(() {
        count = result;
      });
    } on PlatformException catch (e) {
      debugPrint('Kotlin error: ${e.message}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Kotlin SDK'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: $count',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLoading ? null : decrement,
                  child: const Text('Decrement'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : increment,
                  child: const Text('Increment'),
                ),
              ],
            ),
            if (isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}