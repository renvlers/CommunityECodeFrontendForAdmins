import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  // Get User UID
  static Future<int?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Get User Name
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Get User Phone Number
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  // Get User Door Number
  static Future<String?> getRoomNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('roomNumber');
  }
}
