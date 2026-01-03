
import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:notifications_repo/src/models/notifications_res.dart';
import 'package:prefs_storage/prefs_storage.dart';

class NotificationsRepo {
  NotificationsRepo(this.apiClient, this.prefsStorage);
  final ApiClient apiClient;
  final PrefsStorage prefsStorage;

  Future<List<NotificationDetails>> getNotifications() async {
    try {
      final token = prefsStorage.getString(PrefKeys.accessTokenPrefKey);
      final res =
          await apiClient.getReq(ApiPaths.getNotifications, token: token);
      if (res is DataFailed) {
        log(res.error?.error.toString() ?? 'error');
        return [];
      }

      final notifications = notificationResFromJson(res.data?.data);
      return notifications;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
