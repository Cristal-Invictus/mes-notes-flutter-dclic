import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _rememberMeKey = 'remember_me';

  static Future<void> setRemembered(bool value) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _rememberMeKey,
      value,
    );
  }

  static Future<bool> isRemembered() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_rememberMeKey) ?? false;
  }

  static Future<void> clearSession() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_rememberMeKey);
  }
}
