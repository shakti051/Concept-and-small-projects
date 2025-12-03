import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvvm_getx/counter_view_model.dart';

//**In MVVM:

//**View ↔ ViewModel using reactive state

//**ViewModel ↔ Model

//**View never knows Model → Loose Coupling

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
      home: CounterViewMVVM(),
    );
  }
}

class CounterViewMVVM extends StatelessWidget {
  final vm = Get.put(CounterViewModel());

  CounterViewMVVM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MVVM using GetX")),
      body: Center(
        child: Obx(
          () => Text(
            "Value: ${vm.count.value}",
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
