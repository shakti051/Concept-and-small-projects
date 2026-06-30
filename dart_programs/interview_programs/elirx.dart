mixin A {

  void show() {

    print('A');

  }

}
 
mixin B {

  void show() {

    print('B');

  }

}
 
class Test with A,B {}
 
// void main() {

//   Test().show();

// }


void main() {

  print('Start');
 
  fetchData();
 
  print('End');

}
 
Future<void> fetchData() async {

  print('Fetching...');

  await Future.delayed(Duration(seconds: 1));

  print('Data fetched');

}
 