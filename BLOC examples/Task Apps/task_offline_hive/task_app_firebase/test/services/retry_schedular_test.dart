import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/services/retry_scheduler.dart';

void main() {
late RetryScheduler scheduler;

setUp(() {
scheduler = RetryScheduler();
});

tearDown(() {
scheduler.dispose();
});

// ============================================================
// FIRST RETRY
// ============================================================

test('first schedule executes callback after 5 seconds', () async {
var executed = false;


scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 2));

expect(executed, false);

await Future.delayed(const Duration(seconds: 3, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// SECOND RETRY
// ============================================================

test('second schedule executes callback after 10 seconds', () async {
var executed = false;


// First attempt consumes attempt #1.
scheduler.schedule(() {});

await Future.delayed(const Duration(milliseconds: 100));

// Second attempt should use 10 seconds.
scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 5));

expect(executed, false);

await Future.delayed(const Duration(seconds: 5, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// THIRD RETRY
// ============================================================

test('third schedule executes callback after 30 seconds', () async {
var executed = false;


// Attempt 1 -> 5 seconds.
scheduler.schedule(() {});

await Future.delayed(const Duration(milliseconds: 100));

// Attempt 2 -> 10 seconds.
scheduler.schedule(() {});

await Future.delayed(const Duration(milliseconds: 100));

// Attempt 3 -> 30 seconds.
scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 10));

expect(executed, false);

await Future.delayed(const Duration(seconds: 20, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// FOURTH RETRY
// ============================================================

test('fourth schedule also uses 30 seconds', () async {
var executed = false;


// Attempt 1
scheduler.schedule(() {});
await Future.delayed(const Duration(milliseconds: 100));

// Attempt 2
scheduler.schedule(() {});
await Future.delayed(const Duration(milliseconds: 100));

// Attempt 3
scheduler.schedule(() {});
await Future.delayed(const Duration(milliseconds: 100));

// Attempt 4 -> should still be 30 seconds.
scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 10));

expect(executed, false);

await Future.delayed(const Duration(seconds: 20, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// SECOND SCHEDULE CANCELS FIRST
// ============================================================

test('second schedule cancels the first pending callback', () async {
var firstExecuted = false;
var secondExecuted = false;


scheduler.schedule(() {
  firstExecuted = true;
});

await Future.delayed(const Duration(seconds: 2));

scheduler.schedule(() {
  secondExecuted = true;
});

// The first timer would have fired at 5 seconds,
// but it should have been cancelled.
await Future.delayed(const Duration(seconds: 3, milliseconds: 100));

expect(firstExecuted, false);
expect(secondExecuted, false);

// Second attempt uses 10 seconds from when it was scheduled.
await Future.delayed(const Duration(seconds: 7, milliseconds: 100));

expect(firstExecuted, false);
expect(secondExecuted, true);


});

// ============================================================
// RESET
// ============================================================

test('reset resets retry attempts', () async {
var executed = false;


// Consume attempt 1.
scheduler.schedule(() {});

await Future.delayed(const Duration(milliseconds: 100));

// Consume attempt 2.
scheduler.schedule(() {});

await Future.delayed(const Duration(milliseconds: 100));

// Reset attempts.
scheduler.reset();

// This should now be attempt 1 again -> 5 seconds.
scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 2));

expect(executed, false);

await Future.delayed(const Duration(seconds: 3, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// RESET CANCELS PENDING TIMER
// ============================================================

test('reset cancels pending retry callback', () async {
var executed = false;


scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 2));

scheduler.reset();

await Future.delayed(const Duration(seconds: 4));

expect(executed, false);


});

// ============================================================
// DISPOSE
// ============================================================

test('dispose cancels pending retry callback', () async {
var executed = false;


scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 2));

scheduler.dispose();

await Future.delayed(const Duration(seconds: 4));

expect(executed, false);


});

// ============================================================
// DISPOSE WITHOUT SCHEDULE
// ============================================================

test('dispose is safe when no retry is scheduled', () {
expect(() => scheduler.dispose(), returnsNormally);
});
}
