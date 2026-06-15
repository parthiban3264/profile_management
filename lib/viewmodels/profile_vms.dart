import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../model/profile_model.dart';
import '../services/profile_service.dart';

class ProfileVms extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  List<ProfileModel> profiles = [];

  Future<int> getNextId() async {
    return _profileService.getNextId();
  }

  /// Create Profile
  Future<void> addProfile(ProfileModel profile) async {
    await _profileService.createProfile(profile);
    await getProfiles();
  }

  /// Read All Profiles
  Future<dynamic> getProfiles() async {
    profiles = _profileService.getAllProfiles();
    notifyListeners();
  }

  /// Read Single Profile
  ProfileModel? getProfile(int id) {
    return _profileService.getProfile(id);
  }

  /// Clear Profiles
  Future<void> clearProfiles() async {
    await _profileService.clearProfiles();
    await getProfiles();
  }

  /// Delete Profile
  Future<void> deleteProfile(int id) async {
    final box = Hive.box(ProfileService.boxName);

    await box.delete(id);

    await getProfiles();
  }

  /// Update Profile
  Future<void> updateProfile(ProfileModel profile) async {
    await _profileService.updateProfile(profile);

    await getProfiles();
  }
}
