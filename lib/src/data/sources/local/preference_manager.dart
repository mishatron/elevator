import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final String _kAccessToken = "_kAccessToken";
  final String _kUserId = "_kUserId";
  final String _kFirstLaunch = "_kFirstLaunch";

  static final PreferenceManager singleton = PreferenceManager._internal();

  PreferenceManager._internal();

  factory PreferenceManager() => singleton;

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken) ?? "";
  }

  Future<bool> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_kAccessToken, token);
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUserId) ?? -1;
  }

  Future<bool> setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_kUserId, userId);
  }

  Future<bool> getIsFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kFirstLaunch) ?? true;
  }

  Future<bool> setFirstLaunch(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_kFirstLaunch, value);
  }
}
