import '../models/sync_report.dart';

extension SyncReportExtension on SyncReport {
  String get message {
    final parts = <String>[];

    if (uploaded > 0) {
      parts.add("$uploaded uploaded");
    }

    if (updated > 0) {
      parts.add("$updated updated");
    }

    if (deleted > 0) {
      parts.add("$deleted deleted");
    }

    if (parts.isEmpty) {
      parts.add("Everything is already up to date");
    }

    if (failed > 0) {
      parts.add("$failed failed");
    }
    
    return parts.join(", ");
  }
}