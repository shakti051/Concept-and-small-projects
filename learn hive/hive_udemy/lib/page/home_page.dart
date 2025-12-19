import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late Box homeBox;
  
  @override
  void initState() {    
    super.initState();

    homeBox = Hive.box('home');
    homeBox.put('1', 'David 56565');
    homeBox.put('2', 'Ham');
    homeBox.put('3', 'Pop');
    homeBox.putAll({'4':'John','5':'Sam','6':'Richard'});

    homeBox.add('Dewan');
    homeBox.put('10', 'Pan');
    homeBox.add('Van');
  }


  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Text(homeBox.get('1')),
        Text(homeBox.get('2')),
        Text(homeBox.get('3')),
        Text(homeBox.get('4')),
        Text(homeBox.get('5')),
        Text(homeBox.get('6')),
        Text(homeBox.getAt(0)),
        Text(homeBox.getAt(1)),
      ],
    );
  }
}
