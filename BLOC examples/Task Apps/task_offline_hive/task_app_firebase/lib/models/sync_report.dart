enum SyncResult { synced, skipped, failed }

class SyncReport {
  int uploaded;
  int updated;
  int deleted;
  int skipped;
  int failed;

  SyncReport({
    this.uploaded = 0,
    this.updated = 0,
    this.deleted = 0,
    this.skipped = 0,
    this.failed = 0,
  });

  int get total => uploaded + updated + deleted;

  bool get hasFailures => failed > 0;
}
