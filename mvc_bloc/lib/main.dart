import 'package:flutter/material.dart';
import 'package:mvc_bloc/counter_bloc.dart';

//**Main Difference in 1 Line**//

//**👉 MVC: View directly accesses Model through Controller.
//**👉 MVVM: View listens to ViewModel streams but never touches the Model.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final controller = CounterController();

  CounterViewMVC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MVC using BLoC")),

      body: StreamBuilder(
        stream: controller.counterStream,
        initialData: controller.counter, // View accesses MODEL directly
        builder: (context, snapshot) {
          final model = snapshot.data!;
          return Center(
            child: Text(
              "Value: ${model.value}",    // reading model directly
              style:const TextStyle(fontSize: 32),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child:const Icon(Icons.add),
      ),
    );
  }
}


