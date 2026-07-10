//SRP

class LoginRepository {
  void login() => print("User logged in");
}

abstract class Payment {
  void pay();
}

class CardPayment implements Payment {
  @override
  void pay() {
    print("Card payment");
  }
}

class UpiPayment implements Payment {
  @override
  void pay() {
    print("UPI payment");
  }
}

void makePayment(Payment payment) {
  payment.pay();
}

//LSP
abstract class Shape {
  double area();
}

class Rectangle implements Shape {
  @override
  double area() => 100;
}

class Circle implements Shape{
  @override
  double area()=>200;

}

void PrintArea(Shape shape){
shape.area();
}

abstract class Developer{
  void Code();
  void Test();  
}

abstract class Tester{
    void Test();
}

class FlutterDeveloper implements Developer {
  @override
  void Code() {
    print("Developer can code");
  }

  @override
  void Test() {
    print("Developer can test also");
  }

}

class QA implements Tester{

  @override
  void Test() {
    print("QA can test");
  }

}

abstract class MessageService{
    void send();
}

class EmailService implements MessageService{
  @override
  void send() {
    print("Send Email");
  }
}

class SMSService implements MessageService{
  @override
  void send() {
    print("sms sent");
  }

}

class Notification {
    MessageService messageService;
    Notification(this.messageService);
    void notify(){
        messageService.send();
    }
}

void main() { 
}
