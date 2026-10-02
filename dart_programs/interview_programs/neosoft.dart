import 'dart:isolate';

// diamond probleum
//   A
//  / \
// B   C
//  \ /
//   D
class A {
  void show() {
    print('A');
  }
}

class B extends A {
  @override
  void show() {
    print('B');
  }
}

class C extends A {
  @override
  void show() {
    print('C');
  }
}

// class D extends B , C { // Not allowed
//   @override
//   void show() {
//     print('D');
//   }
// }

class D implements B, C {
  @override
  void show() {
    // TODO: implement show
  }
}

// void main() {
//   D d = D();
//   d.show();
// }

//Isolate.run
// Future<void> main() async {
//   final result = await Isolate.run(calculateSum);

//   print(result);
// }

int calculateSum() {
  int sum = 0;

  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }

  return sum;
}

//isolate.span
void worker(SendPort sendPort) {
  final result = 100 + 200;

  sendPort.send(result);
  sendPort.send(500);
}

// Future<void> main() async {
//   final receivePort = ReceivePort();

//   await Isolate.spawn(worker, receivePort.sendPort);

//   receivePort.listen((message) {
//     print('Result: $message');
//    // receivePort.close();
//   });
// }
//dispose the isolate

void worker1(SendPort sendPort) {
  // Do some work
  final result = 100 + 200;

  sendPort.send(result);
  sendPort.send(500);
  // Explicitly tell main isolate that there is no more work.
  sendPort.send(null);
}

// Future<void> main() async {
//   final receivePort = ReceivePort();

//   final isolate = await Isolate.spawn(
//     worker1,
//     receivePort.sendPort,
//   );

//   receivePort.listen((message) {
//     if (message != null) {
//       print('Result: $message');
//       return;
//     }

//     // Worker says: "I have nothing more to send."
//     print('Worker finished');

//     receivePort.close();

//     isolate.kill(
//       priority: Isolate.immediate,
//     );

//     print('Isolate terminated');
//   });
// }

//exit isolate

void worker2(SendPort mainSendPort) {
  final result = 100 + 200;
  mainSendPort.send(500);
  // Worker finishes normally
  Isolate.exit(mainSendPort, result);
}

Future<void> main() async {
  final receivePort = ReceivePort();

  final isolate = await Isolate.spawn(
    worker2,
    receivePort.sendPort,
  );

  receivePort.listen((message) {
    print('Result: $message');
  });
}

//2nd example
void worker3(SendPort mainSendPort) {
  final receivePort = ReceivePort();

  // Send worker's SendPort back to main isolate.
  mainSendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    final number = message as int;

    final result = number * number;

    mainSendPort.send(result);
  });
}

// Future<void> main() async {
//   final receivePort = ReceivePort();

//   await Isolate.spawn(
//     worker3,
//     receivePort.sendPort,
//   );

//   late SendPort workerSendPort;

//   receivePort.listen((message) {
//     if (message is SendPort) {
//       workerSendPort = message;

//       workerSendPort.send(10);
//       workerSendPort.send(20);
//       workerSendPort.send(30);
//     } else {
//       print('Result: $message');
//     }
//   });
// }

