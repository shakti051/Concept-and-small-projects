import 'package:flutter_test/flutter_test.dart';

class Engine {
  void start() {}
}

class FakeEngine extends Engine {
  bool started = false;

  @override
  void start() {
    started = true;
  }
}

class Car {
  final Engine engine;

  Car(this.engine);

  void drive() {
    engine.start();
  }
}

void main() {
  test('Engine should be started', () {
    final fakeEngine = FakeEngine();
    final car = Car(fakeEngine);

    car.drive();

    expect(fakeEngine.started, true);
  });
}