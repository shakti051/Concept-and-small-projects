
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

abstract class Animal {
  Animal() {
    print("Animal constructor");
  }
}

class Dog extends Animal {
  Dog() 
  {
    print("Dog constructor");
  }
}

void main() {
  Dog();
}