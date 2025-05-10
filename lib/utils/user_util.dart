import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  // Get User UID
  static Future<int?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Get User Phone Number
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }
}
