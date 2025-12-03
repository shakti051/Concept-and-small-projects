import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvc_getx/counter_controller.dart';

//**In MVC:

//*View → Controller → Model

//*View directly depends on Controller (Tight Coupling)


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CounterViewMVC(),
    );
  }
}

class CounterViewMVC extends StatelessWidget {
  final controller = Get.put(CounterController());

  CounterViewMVC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MVC using GetX")),
      body: Center(
        child: Obx(
          () => Text(
            "Value: ${controller.model.value.count}",
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
