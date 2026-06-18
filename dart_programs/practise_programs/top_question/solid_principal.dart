// SRP
class LoginService {
  void login() {
    print("user Logged in");
  }
}

class EmailService {
  void sendEmail() {
    print("email sent");
  }
}

//OCP
abstract class Payment {
  void pay();
}

class CardPayment implements Payment {
  @override
  void pay() {
    print("card payment");
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
//if tomorrow if new payment come like net banking

class NetBankingPayment implements Payment {
  @override
  void pay() {
    // TODO: implement pay
  }
}

//LSP
abstract class Shape {
  double area();
}

class Circle implements Shape {
  @override
  double area() => 100;
}

class Rectangle implements Shape {
  @override
  double area() => 200;
}

void printArea(Shape shape) {
  print(shape.area());
}

// ISP
abstract class Developer {
  void code();
}

abstract class Tester {
  void test();
}
class FlutterDeveloer implements Developer{
  @override
  void code() {
    print("Writing flutter code");
  }
}
class QATester implements Tester {
  @override
  void test() {
    print("Testing flutter app");
  }
  
}
// DIP
abstract class MessageService {
  void send();
}

class SendEmailService implements MessageService {
  @override
  void send() {
    print("Send Email");
  }
}

class SendSmsService implements MessageService{
  @override
  void send() {
    print("SMS sent");
  }
}

class Notification {
  final MessageService service;
  Notification(this.service);// Dependency Injection
  void notify() {
    service.send();
  }
}

void main() {
  LoginService().login();
  EmailService().sendEmail();
  makePayment(CardPayment());
  makePayment(UpiPayment());
  printArea(Circle());
  printArea(Rectangle());
  FlutterDeveloer().code();
  QATester().test();
 Notification(SendEmailService()).notify();
 Notification(SendSmsService()).notify();
}
