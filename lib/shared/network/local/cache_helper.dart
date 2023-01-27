// ignore_for_file: non_constant_identifier_names, await_only_futures

import 'package:shared_preferences/shared_preferences.dart';

class cachHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> SaveData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      return await sharedPreferences?.setInt(key, value);
    } else if (value is String) {
      return await sharedPreferences?.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences?.setBool(key, value);
    } else {
      return await sharedPreferences?.setDouble(key, value);
    }
  }

  static dynamic GetData({String? key}) {
    return sharedPreferences?.get(key!);
  }

  static Future<bool?>? DeleteItem({required String key}) async {
    return await sharedPreferences?.remove(key);
  }
}
