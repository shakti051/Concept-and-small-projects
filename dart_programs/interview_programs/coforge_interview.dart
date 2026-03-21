
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
  
  String result = "";
  int largest = -1 << 31;
  int second = -1 << 31;
  for (var employee in data) {
     if(employee.salary> largest){
      second = largest;
      largest = employee.salary;
     }else if(employee.salary> second && employee.salary!=largest){
      second= employee.salary;
    result = employee.name;
     }
  }
  print(result);
  print(second);	    
}


