import 'dart:isolate';

void isolateA(SendPort mainSendPort) {
  final receivePortA = ReceivePort();

  // Send A's SendPort to Main
  mainSendPort.send(receivePortA.sendPort);

  receivePortA.listen((message) {
    if (message is SendPort) {
      // This is B's SendPort
      final sendPortB = message;

      // A → B
      sendPortB.send('Hello from Isolate A');
    } else {
      // B → A
      print('Isolate A received: $message');
    }
  });
}

void isolateB(SendPort isolateASendPort) {
  final receivePortB = ReceivePort();

  // Send B's SendPort directly to A
  isolateASendPort.send(receivePortB.sendPort);

  receivePortB.listen((message) {
    // A → B
    print('Isolate B received: $message');

    // B → A
    isolateASendPort.send('Hello from Isolate B');
  });
}

Future<void> main() async {
  final mainReceivePort = ReceivePort();

  // Start A
  await Isolate.spawn(
    isolateA,
    mainReceivePort.sendPort,
  );

  // Main receives A's SendPort
  mainReceivePort.listen((message) {
    if (message is SendPort) {
      final isolateASendPort = message;

      // Start B and give B A's SendPort
      Isolate.spawn(
        isolateB,
        isolateASendPort,
      );
    }
  });
}