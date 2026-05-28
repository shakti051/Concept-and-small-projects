
class Employee{
  String name;
  int salary;
  Employee(this.name,this.salary);
}

void main() {
 var data = [
     Employee("Alice", 5000),
     Employee("Bob", 7000),
     Employee("Charlie", 6000),
     Employee("David", 7000),
     Employee("Adams", 6000),
  ];

Employee highest = data.reduce((a,b)=> a.salary > b.salary ? a : b);
print(highest.name);
print(highest.salary);  
}


