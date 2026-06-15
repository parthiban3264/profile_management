import 'package:profile_management/model/auth_model.dart';

import '../services/auth_service.dart';

class AuthVms {
  AuthService authService = AuthService();
  Future<void> registerUserData(AuthModel authModel) {
    return authService.registerUserData(authModel);
  }

  dynamic checkUserData(String userName) {
    return authService.checkUserData(userName);
  }

  Future<void> updateProfile(AuthModel auth) async {
    await authService.updateProfile(auth);
  }

  /// Clear Profiles
  Future<void> clearProfiles() async {
    await authService.clearProfiles();
  }
}
