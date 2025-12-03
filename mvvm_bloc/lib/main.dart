import 'package:flutter/material.dart';
import 'package:mvvm_bloc/counter_bloc.dart';

/*━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🟦 MVVM SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟩 ✔ ViewModel exposes pure reactive data
🟩 ✔ View listens to streams and rebuilds
🟩 ✔ View does NOT know the Model
🟩 ✔ Loose coupling between View ↔ ViewModel
🟩 ✔ Best suited for medium to large applications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/

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
  final bloc = CounterViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("MVVM using BLoC")),
      body: StreamBuilder<int>(
        stream: bloc.counterStream,
        initialData: 0,
        builder: (context, snapshot) {
          return Center(
            child: Text(
              "Value: ${snapshot.data}",
              style:const TextStyle(fontSize: 32),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: bloc.increment,
        child:const Icon(Icons.add),
      ),
    );
  }
}
