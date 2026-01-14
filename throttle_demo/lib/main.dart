import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    _timer?.cancel(); // cancel previous timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}


class Throttle {
  final int milliseconds;
  bool _ready = true;

  Throttle(this.milliseconds);

  call(Function action) {
    if (_ready) {
      _ready = false;
      action();

      Future.delayed(Duration(milliseconds: milliseconds), () {
        _ready = true;
      });
    }
  }
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final search = TextEditingController();
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

final throttle = Throttle(10000); // 1 second throttle

onButtonPressed() {
  throttle(() {
    print("Button clicked!");
  });
}

final debouncer = Debouncer(10000); // 500ms

onTextChanged(String value) {
  debouncer.run(() {
    print("Searching for $value");
  });
}


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           TextFormField(controller: search,
           onChanged: onTextChanged,
           )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onButtonPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
