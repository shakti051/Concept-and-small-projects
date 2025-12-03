import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int counter1=0;
  int counter2=0;
  int counter3=0;
  final ValueNotifier<int> counter = ValueNotifier(0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: counter,
                    builder: (context,value,_){
                      return Text("count $value");
                    },
                    // child: Card(
                    //   child: Text("Hello $counter1"),
                    // ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Text(
                        "Hell0 $counter2"),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Text("Hello2 $counter3"),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
               counter.value++;
                // setState(() {
                //   counter1++;
                // });
                debugPrint("");
              },
              child: const Text("Increase cunter 1")),
          TextButton(
              onPressed: () {
                setState(() {
                  counter2++;
                });
                debugPrint("");
              },
              child: const Text("Increase cunter 2")),
              TextButton(
              onPressed: () {
                setState(() {
                  counter3++;
                });
                debugPrint("");
              },
              child: const Text("Increase cunter 3"))    
        ],
      ),
    );
  }
}
