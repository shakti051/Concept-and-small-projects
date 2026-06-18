
class Engine{
    void start(){
        print("Engine started...");
    }
}

class Car{
    final Engine engine;
    Car(this.engine);//dependency injection
    void drive(){
        engine.start();
        print("Car is moving..");
    }
}

void main() {
  final engine = Engine();
  final car = Car(engine);
  car.drive();  
}
