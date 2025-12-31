import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:auth_repo/src/models/creds.dart';
import 'package:auth_repo/src/models/login_res.dart';
import 'package:prefs_storage/prefs_storage.dart';


class AuthRepo {
  AuthRepo(this.apiClient, this.prefs);
  final PrefsStorage prefs;
  final ApiClient apiClient;

  bool checkIfSignedIn() {
    final token = prefs.getString(PrefKeys.accessTokenPrefKey);
    return token != '';
  }

  void logout() {
    prefs.saveString(PrefKeys.accessTokenPrefKey, '');
  }

  Future<String?> register(Creds creds) async {
    try {
      final res = await apiClient.postReq(ApiPaths.createUser,
          bodyJson: creds.toJson());

      if (res is DataFailed) {
        return jsonDecode(res.error?.error)['msg'] ?? 'some error occured';
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(Creds creds) async {
    try {
      final res =
          await apiClient.postReq(ApiPaths.login, bodyJson: creds.toJson());

      if (res is DataFailed) {
        return jsonDecode(res.error?.error)['msg'] ?? 'some error occured';
      }

      // save the token in prefs
      final data = loginResFromJson(res.data?.data);

      prefs.saveString(PrefKeys.accessTokenPrefKey, data.accessToken);

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
