import 'dart:io';

import 'package:flutter/material.dart';
import 'package:profile_management/color/colors.dart';
import '../../viewmodels/profile_vms.dart';
import '../../widgets/appbar.dart';
import '../../widgets/snackBar_messages.dart';
import '../home/home_screen.dart';
import 'create_profile_screen.dart';

class ManageProfileScreen extends StatefulWidget {
  final dynamic profileData;

  const ManageProfileScreen({super.key, required this.profileData});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  final ProfileVms profileVms = ProfileVms();
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();

  Future<void> showDeleteConfirmation() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Profile'),
            ],
          ),
          content: const Text('Are you sure you want to delete this profile?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await profileVms.deleteProfile(widget.profileData.id);

      if (mounted) {
        snackBarMessenger.showSnackBar(
          context,
          'Profile Deleted Successfully',
          Icons.check_circle,
          Colors.green,
          Colors.green[100]!,
        );
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        snackBarMessenger.showSnackBar(
          context,
          'Profile Deleted Failed',
          Icons.cancel,
          Colors.redAccent,
          Colors.red[100]!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileData;
    print('profile: $profile');

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          title: 'Profile Details',
          pop: true,
          setting: true,
          drawer: false,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xff1E3A8A), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Strip
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateProfileScreen(
                                  isEdit: true,
                                  profile: profile,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                color: background,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            showDeleteConfirmation();
                          },
                          child: Row(
                            children: const [
                              Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.delete_outline,
                                color: background,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: profile.favorite
                            ? Colors.green
                            : Colors.red,
                        child: Icon(
                          profile.favorite ? Icons.thumb_up : Icons.thumb_down,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    profile.occupation,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _idRow(
                            Icons.badge_outlined,
                            "Gender",
                            profile.gender,
                          ),

                          const Divider(),

                          _idRow(
                            Icons.cake_outlined,
                            "Age",
                            "${profile.age} Yrs",
                          ),

                          const Divider(),
                          _idRow(
                            Icons.cake_outlined,
                            "Phone",
                            "${profile.phone.toString().isEmpty ? "N/A" : profile.phone}",
                          ),

                          const Divider(),

                          _idRow(Icons.email_outlined, "Email", profile.email),

                          const Divider(),

                          _idRow(
                            Icons.location_on_outlined,
                            "Location",
                            profile.location,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person_outline, color: primaryColor),
                              SizedBox(width: 8),
                              Text(
                                "ABOUT ME",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          Text(
                            profile.aboutMe.isEmpty
                                ? "No description available"
                                : profile.aboutMe,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: primaryColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: profile.profileImage.toString().isNotEmpty
                        ? FileImage(File(profile.profileImage))
                        : null,
                    child: profile.profileImage.toString().isEmpty
                        ? const Icon(Icons.person, size: 55, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _idRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xff1E3A8A)),
        const SizedBox(width: 12),

        SizedBox(
          width: 75,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Text(":  "),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
