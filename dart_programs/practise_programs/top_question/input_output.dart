
// abstract class A {
//   void show() {
//     print("A");
//   }
// }

// class B extends A {
//   @override
//   void show() {
//     super.show();
//     print("B");
//   }
// }

// void main() {
//   A obj = B();

//   obj.show();
// }


// abstract class Animal {
//   void sound();

//   void eat() {
//     print("Eating");
//   }
// }

// class Dog extends Animal {
//   @override
//   void sound() {
//     print("Bark");
//   }
// }

// void main() {
//   Dog().eat();
// }


// class A {
//   static final A _instance = A._();

//   factory A() => _instance;

//   A._();
// }


// void main() {
//   var a = A();

//   var b = A();

//   print(a.hashCode == b.hashCode);
// }

// 


// class A {
//   factory A() {
//     return B();
//   }

//   void show() {
//     print("A");
//   }
// }

// class B implements A {
//   @override
//   void show() {
//     print("B");
//   }
// }


// void main() {
//   A().show();
// }


// class A {
//   factory A() {
//     print("Factory");
//     return A._();
//   }

//   A._() {
//     print("Private");
//   }
// }

// void main() {
//   A();
// }


// class A {
//   void show() {
//     print("A");
//   }
// }

// class B extends A {
//   @override
//   void show() {
//     print("B");
//   }
// }

// void main() {
//   A obj = B();

//   obj.show();
// }

// class A {
//   int value = 10;
// }

// class B extends A {
//   int value = 20;
// }

// void main() {
//   B obj = B();

//   print(obj.value);
//   print("object");
//   print((obj as A).value);
// }
//imp

// class A {
//   A() {
//     print("A");
//   }
// }

// class B extends A {
//   B() {
//     print("B");
//   }
// }

// class C extends B {
//   C() {
//     print("C");
//   }
// }

// void main() {
//   C();
// }
//imp child can inherit code

// 

// class A {
//   void show() {
//     print("A");
//   }
// }

// class B extends A {
//   @override
//   void show() {
//     super.show();
//     print("B");
//   }
// }

// void main() {
//   B().show();
// }
//imp

// abstract class A {
//   A() {
//     print("A Constructor");
//   }

//   void show() {
//     print("A Show");
//   }
// }

// class B extends A {
//   B() {
//     print("B Constructor");
//   }

//   @override
//   void show() {
//     super.show();
//     print("B Show");
//   }
// }

// void main() {
//   B().show();
// }

// abstract class A {
//   void show() {
//     print("A");
//   }
// }

// class B implements A {
//   @override
//   void show() {
    
//     print("B");
//   }
// }

// void main() {
//   B().show();
// }

// abstract class A {
//   A(String name) {
//     print(name);
//   }
// }

// class B extends A {
//   B() : super("Flutter");
// }

// void main() {
//   B();
// }

// abstract class Animal {
//   void sound();

//   void eat() {
//     print("Eating");
//   }
// }

// class Dog extends Animal {
//   @override
//   void sound() {
//     print("Bark");
//   }
// }

// void main() {
//   Dog().eat();
//   Dog().sound();
// }
// if parent having method you don't need to override

// class Animal {
//   Animal() {
//     print("Animal constructor");
//   }

//   void eat() {
//     print("Animal is eating");
//   }
// }

// class Dog extends Animal {
//   Dog();
  
//   void bark() {
//     print("Dog is barking");
//   }
// }

// void main() {
//   Dog().eat();
// }

// abstract class Animal {
//   Animal() {
//     print("Animal constructor");
//   }
// }

// class Dog extends Animal {
//   Dog() 
//   {
//     print("Dog constructor");
//   }
// }

// void main() {
//   Dog();
// }

import 'dart:async';
//imp
// void main() async{
//   print("A");

// Future(() => print("B"));

// scheduleMicrotask(() => print("C"));

// await Future.delayed(Duration.zero);

// print("D");
// }
//imp

// void main() {
//   List<int> list = [1, 2, 3];

//   var result = list.map((e) => e + 1);

//   list.add(4);

//   print(result.toList());
// }

// void main() {
//   var numbers = [2, 4, 6, 8];

//   print(numbers.every((e) => e.isEven));
// }

// void main() {
//   var a = {"x": 1};

//   var b = {"x": 1};

//   print(a == b);

//   print(identical(a, b));
// }

// void main() {
//   const a = {"x": 1};

//   const b = {"x": 1};

//   print(identical(a, b));
// }

// void main() async {
//   print("A");

//   await Future.delayed(Duration(seconds: 1), () {
//     print("B");
//   });

//   print("C");
// }

// void main() async {
//   print("A");

//   Future.delayed(Duration(seconds: 1), () {
//     print("B");
//   });

//   print("C");
// }


// void main() {
//   var list = [1, 2, 3];

//   for (var item in List.from(list)) {
//     if (item == 2) {
//       list.add(4);
//     }
//   }

//   print(list);
// }

//imp
// void main() {
//   print("1");

//   Future.delayed(Duration.zero, () {
//     print("2");
//   });

//   Future.microtask(() {
//     print("3");
//   });

//   print("4");
// }

//imp

// void main(){
//   print("A");

// Future.sync(() {
//   print("B");
// });

// print("C");
// }

// class Test {
//   factory Test() {
//     print("Factory");
//     return Test._internal();
//   }

//   Test._internal() {
//     print("Internal");
//   }
// }

// void main() {
//   Test();
// }

// class A {
//   A() {
//     print("A");
//   }
// }

// class B extends A {
//   B() : super() {
//     print("B");
//   }
// }

// void main() {
//   B();
// }

// void main() async {
//   Stream<int> stream = Stream.fromIterable([1, 2, 3]);

//   await for (var value in stream) {
//     print(value);
//   }

//   print("Done");
// }

//imp

// void main() {
//   print("1");

//   Future(() => print("2"));

//   Future.microtask(() => print("3"));

//   print("4");
// }
//imp

// void main() {
//   List<int> list = [1, 2, 3];

//   for (var item in list) {
//     if (item == 2) {
//       list.add(4);
//     }
//     print(item);
//   }
// }

// void main() {
//   List<int> list = [1, 2, 3];

//   for (int i = 0; i < list.length; i++) {
//     if (list[i] == 2) {
//       list.add(4);
//     }
//     print(list[i]);
//   }
// }

//imp
// void main() {
//   var a = [1, 2];

//   var b = [1, 2];

//   print(a == b);

//   print(identical(a, b));
// }
// 


// mixin A {
//   void show() {
//     print("A");
//   }
// }

// mixin B {
//   void show() {
//     print("B");
//   }
// }

// mixin C {
//   void show() {
//     print("C");
//   }
// }

// class Test with A, B, C {}

// void main() {
//   Test().show();
// }
//imp

// void main() async {
//   print("A");

//   await Future.wait([
//     Future.delayed(Duration(seconds: 1), () => print("B")),
//     Future.delayed(Duration(seconds: 2), () => print("C")),
//   ]);

//   print("D");
// }
//imp

// void main() {
//   var a = [1, 2];

//   var b = a;

//   b = [3, 4];

//   print(a);
//   print(b);
// }

// class A {
//   void show() {
//     print("A");
//   }
// }

// class B extends A {
//   @override
//   void show() {
//     super.show();
//     print("B");
//   }
// }

// void main() {
//   B().show();
// }

// class A {
//   void show() {
//     print("A");
//   }
// }

// class B extends A {
//   @override
//   void show() {
//     print("B");
//   }
// }

// void main() {
//   A obj = B();

//   obj.show();
// }
//imp
// class Test {
//   static int count = 0;

//   Test() {
//     count++;
//   }
// }

// void main() {
//   Test();
//   Test();
//   Test();

//   print(Test.count);
// }
//imp

// class A {
//   A() {
//     print("A");
//   }
// }

// class B extends A {
//   B() {
//     print("B");
//   }
// }

// class C extends B {
//   C() {
//     print("C");
//   }
// }

// void main() {
//   C();
// }
//imp
// class Test {
//   Test() {
//     print("Default");
//   }

//   Test.named() {
//     print("Named");
//   }
// }

// void main() {
//   Test.named();
// }
//imp

// void main() {
//   String a = "Flutter";
//   String b = "Flutter";

//   print(identical(a, b));
// }

// class A {
//   A() {
//     print("A");
//   }
// }

// class B extends A {
//   B() {
//     print("B");
//   }
// }

// void main() {
//   B();
// }

// class Test {
//   factory Test() {
//     print("Factory");
//     return Test._();
//   }

//   Test._() {
//     print("Constructor");
//   }
// }

// void main() {
//   Test();
// }
//imp

// void main() {
//   List<int> a = [1, 2];

//   List<int> b = [...a];

//   b.add(3);

//   print(a);
//   print(b);
// }

// void main() {
//   final a = [1, 2];
//   final b = [1, 2];

//   print(identical(a, b));
// }

// void main() {
//   const a = [1, 2];
//   const b = [1, 2];

//   print(identical(a, b));
// }

// void main() {
//   List<int> a = [1, 2];

//   List<int> b = a;

//   b.add(3);

//   print(a);
// }