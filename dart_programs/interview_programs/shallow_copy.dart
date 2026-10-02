class Address {
  String city;

  Address(this.city);
}

class User {
  String name;
  Address address;

  User(this.name, this.address);
}
//shallow copy

// void main() {
//   final original = User(
//     'Shakti',
//     Address('Delhi'),
//   );

//   // Shallow copy
//   final copy = User(
//     original.name,
//     original.address, // SAME Address object
//   );

//   copy.name = 'Rahul';
//   copy.address.city = 'Mumbai';

//   print(original.name);          // Shakti
//   print(original.address.city);  // Mumbai
// }

//deep copy

// void main() {
//   final original = User(
//     'Shakti',
//     Address('Delhi'),
//   );

//   // Deep copy
//   final copy = User(
//     original.name,
//     Address(original.address.city),
//   );

//   copy.name = 'Rahul';
//   copy.address.city = 'Mumbai';

//   print(original.name);          // Shakti
//   print(original.address.city);  // Delhi

//   print(copy.name);              // Rahul
//   print(copy.address.city);      // Mumbai
// }


void main() {
  final original = [
    ['Apple', 'Banana'],
    ['Mango', 'Orange'],
  ];

  // Shallow copy
  final shallowCopy = [...original];

  shallowCopy[0][0] = 'Grapes';

  print('Original after shallow copy modification:');
  print(original);

  // Deep copy
  final deepCopy = original
      .map((innerList) => [...innerList])
      .toList();

  deepCopy[0][0] = 'Pineapple';

  print('Original after deep copy modification:');
  print(original);

  print('Deep copy:');
  print(deepCopy);
}