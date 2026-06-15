import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String boxName = 'session';

  final box = Hive.box(boxName);

  void saveSession(String userName) async {
    box.put("isLoggedIn", true);
    box.put("userName", userName);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString("userName", userName);
  }

  bool get isLoggedIn => box.get("isLoggedIn") ?? false;

  String? get currentUser => box.get("userName");

  void clearSession() {
    box.clear();
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) => value.clear());
  }
}
