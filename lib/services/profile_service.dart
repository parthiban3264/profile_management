import 'package:hive_flutter/hive_flutter.dart';
import '../model/profile_model.dart';

class ProfileService {
  static const String boxName = 'profile';

  Box get _box => Hive.box(boxName);

  Future<int> getNextId() async {
    final profiles = getAllProfiles();

    if (profiles.isEmpty) {
      return 1;
    }

    return profiles.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// Create
  Future<void> createProfile(ProfileModel profile) async {
    await _box.put(profile.id, profile.toJson());
  }

  /// Read Single Profile
  ProfileModel? getProfile(int id) {
    final data = _box.get(id);

    if (data == null) return null;

    return ProfileModel.fromJson(data);
  }

  /// Read All Profiles
  List<ProfileModel> getAllProfiles() {
    return _box.values.map((e) => ProfileModel.fromJson(e)).toList();
  }

  Future<void> clearProfiles() async {
    await _box.clear();
  }

  /// Update
  Future<void> updateProfile(ProfileModel profile) async {
    await _box.put(profile.id, profile.toJson());
  }

  /// Delete
  Future<void> deleteProfile(int id) async {
    await _box.delete(id);
  }
}
