import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/services/sync_queue.dart';

void main() {
late SyncQueue syncQueue;

setUp(() {
syncQueue = SyncQueue();
});

// ============================================================
// ENQUEUE
// ============================================================

test('enqueue executes sync callback after 1 second', () async {
var executed = false;

syncQueue.enqueue(() {
  executed = true;
});

expect(executed, false);

await Future.delayed(const Duration(milliseconds: 500));

expect(executed, false);

await Future.delayed(const Duration(milliseconds: 600));

expect(executed, true);


});

// ============================================================
// ONLY ONE CALLBACK EXECUTES
// ============================================================

test('second enqueue cancels the first callback', () async {
var firstExecuted = false;
var secondExecuted = false;


syncQueue.enqueue(() {
  firstExecuted = true;
});

// Enqueue another operation before the first timer fires.
await Future.delayed(const Duration(milliseconds: 500));

syncQueue.enqueue(() {
  secondExecuted = true;
});

// Wait for the second timer.
await Future.delayed(const Duration(milliseconds: 1100));

expect(firstExecuted, false);
expect(secondExecuted, true);


});

// ============================================================
// MULTIPLE ENQUEUE
// ============================================================

test('multiple enqueue calls execute only the latest callback', () async {
final executed = <int>[];


syncQueue.enqueue(() {
  executed.add(1);
});

await Future.delayed(const Duration(milliseconds: 200));

syncQueue.enqueue(() {
  executed.add(2);
});

await Future.delayed(const Duration(milliseconds: 200));

syncQueue.enqueue(() {
  executed.add(3);
});

await Future.delayed(const Duration(milliseconds: 1100));

expect(executed, [3]);


});

// ============================================================
// CALLBACK EXECUTES ONLY ONCE
// ============================================================

test('enqueued callback executes only once', () async {
var executionCount = 0;


syncQueue.enqueue(() {
  executionCount++;
});

await Future.delayed(const Duration(milliseconds: 1100));

expect(executionCount, 1);


});

// ============================================================
// ENQUEUE AFTER PREVIOUS CALLBACK EXECUTED
// ============================================================

test('can enqueue another callback after previous callback executes', () async {
final executed = <int>[];


syncQueue.enqueue(() {
  executed.add(1);
});

await Future.delayed(const Duration(milliseconds: 1100));

expect(executed, [1]);

syncQueue.enqueue(() {
  executed.add(2);
});

await Future.delayed(const Duration(milliseconds: 1100));

expect(executed, [1, 2]);


});

// ============================================================
// RAPID ENQUEUE
// ============================================================

test('rapid enqueue keeps only the final callback', () async {
var executionCount = 0;


for (var i = 0; i < 5; i++) {
  syncQueue.enqueue(() {
    executionCount++;
  });

  await Future.delayed(const Duration(milliseconds: 100));
}

await Future.delayed(const Duration(milliseconds: 1100));

expect(executionCount, 1);


});
}
