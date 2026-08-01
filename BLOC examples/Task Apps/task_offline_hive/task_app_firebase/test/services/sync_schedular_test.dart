import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/services/sync_schedular.dart';

void main() {
late SyncScheduler scheduler;

setUp(() {
scheduler = SyncScheduler();
});

tearDown(() {
scheduler.dispose();
});

// ============================================================
// SCHEDULE
// ============================================================

test('schedule executes callback after 5 seconds', () async {
var executed = false;


scheduler.schedule(() {
  executed = true;
});

expect(executed, false);

await Future.delayed(const Duration(seconds: 5, milliseconds: 100));

expect(executed, true);


});

// ============================================================
// CALLBACK SHOULD NOT EXECUTE BEFORE 5 SECONDS
// ============================================================

test('schedule does not execute callback before 5 seconds', () async {
var executed = false;


scheduler.schedule(() {
  executed = true;
});

await Future.delayed(const Duration(seconds: 2));

expect(executed, false);


});

// ============================================================
// SECOND SCHEDULE CANCELS FIRST
// ============================================================

test('second schedule cancels the first callback', () async {
var firstExecuted = false;
var secondExecuted = false;


scheduler.schedule(() {
  firstExecuted = true;
});

await Future.delayed(const Duration(seconds: 2));

scheduler.schedule(() {
  secondExecuted = true;
});

await Future.delayed(const Duration(seconds: 3, milliseconds: 100));

expect(firstExecuted, false);
expect(secondExecuted, false);

await Future.delayed(const Duration(seconds: 2, milliseconds: 100));

expect(firstExecuted, false);
expect(secondExecuted, true);


});

// ============================================================
// MULTIPLE SCHEDULES
// ============================================================

test('multiple schedules execute only the latest callback', () async {
final executed = <int>[];


scheduler.schedule(() {
  executed.add(1);
});

await Future.delayed(const Duration(seconds: 1));

scheduler.schedule(() {
  executed.add(2);
});

await Future.delayed(const Duration(seconds: 1));

scheduler.schedule(() {
  executed.add(3);
});

await Future.delayed(const Duration(seconds: 5, milliseconds: 100));

expect(executed, [3]);


});

// ============================================================
// DISPOSE
// ============================================================

test('dispose cancels pending callback', () async {
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

test('dispose is safe when nothing is scheduled', () {
expect(() => scheduler.dispose(), returnsNormally);
});
}
