import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/models/sync_report.dart';
import 'package:task_app_firebase/models/task.dart';

void main() {
  group('SyncReport', () {
    test('should use default values when no arguments are provided', () {
      final report = SyncReport();

      expect(report.tasks, isEmpty);
      expect(report.uploaded, 0);
      expect(report.updated, 0);
      expect(report.deleted, 0);
      expect(report.failed, 0);
      expect(report.total, 0);
      expect(report.hasFailures, false);
    });

    test('total should return uploaded + updated + deleted', () {
      final report = SyncReport(uploaded: 3, updated: 2, deleted: 1);

      expect(report.total, 6);
    });

    test('total should not include failed operations', () {
      final report = SyncReport(uploaded: 3, updated: 2, deleted: 1, failed: 5);

      expect(report.total, 6);
    });

    test('hasFailures should return false when failed is zero', () {
      final report = SyncReport(uploaded: 2, updated: 1, deleted: 1, failed: 0);

      expect(report.hasFailures, false);
    });

    test('hasFailures should return true when failed is greater than zero', () {
      final report = SyncReport(uploaded: 2, updated: 1, deleted: 1, failed: 1);

      expect(report.hasFailures, true);
    });

    test('should store tasks correctly', () {
      final task = Task(
        id: 'task-1',
        title: 'Test Task',
        description: 'Description',
        date: '2026-07-30',
        isDone: false,
        isDeleted: false,
        isFavorite: false,
        syncStatus: SyncStatus.synced,
        lastModified: DateTime(2026, 7, 30),
        ownerId: 'test-owner-1',
      );

      final report = SyncReport(tasks: [task], uploaded: 1);

      expect(report.tasks.length, 1);
      expect(report.tasks.first, task);
      expect(report.uploaded, 1);
      expect(report.total, 1);
      expect(report.hasFailures, false);
    });
  });
}
