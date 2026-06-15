import 'package:hive_flutter/hive_flutter.dart';
import 'package:profile_management/model/auth_model.dart';

class AuthService {
  static const String boxName = 'auth';

  Future<void> registerUserData(AuthModel auth) {
    return Hive.box(boxName).put(auth.userName, {
      'userName': auth.userName,
      'password': auth.password,
      'luckyNo': auth.luckyNo,
    });
  }

  dynamic checkUserData(String userName) {
    return Hive.box(boxName).get(userName);
  }

  Future<void> updateProfile(AuthModel auth) async {
    await Hive.box(boxName).put(auth.userName, {
      'userName': auth.userName,
      'password': auth.password,
      'luckyNo': auth.luckyNo,
    });
  }

  Future<void> clearProfiles() async {
    await Hive.box(boxName).clear();
  }
}
