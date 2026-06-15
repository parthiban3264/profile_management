import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../services/session_service.dart';
import '../../widgets/appbar.dart';
import 'package:get/get.dart';

import '../../widgets/snackBar_messages.dart';
import '../auth/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SnackBarMessenger snackBarMessenger = SnackBarMessenger();
  final SessionService sessionService = SessionService();
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          title: 'Settings',
          pop: true,
          setting: false,
          drawer: false,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                  if (isDarkMode) {
                    Get.changeTheme(ThemeData.dark());
                    snackBarMessenger.showSnackBar(
                      context,
                      'Dark Mode Enabled',
                      Icons.check_circle,
                      Colors.green,
                      Colors.green[100]!,
                    );
                  } else {
                    Get.changeTheme(ThemeData.light());
                    snackBarMessenger.showSnackBar(
                      context,
                      'Light Mode Enabled',
                      Icons.check_circle,
                      Colors.green,
                      Colors.green[100]!,
                    );
                  }
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade400, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDarkMode ? 'Light Mode' : 'Dark Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sessionService.clearSession();
                  snackBarMessenger.showSnackBar(
                    context,
                    'Logout Successfully',
                    Icons.check_circle,
                    Colors.green,
                    Colors.green[100]!,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Card(
                  color: Colors.red.shade50,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade400, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.logout, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
