import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:profile_management/views/auth/login_screen.dart';
import 'package:profile_management/views/auth/register_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:profile_management/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/profile_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('auth');
  await Hive.openBox('session');
  await Hive.openBox('profile');
  //bool isLoggedIn = Hive.box('session').get('isLoggedIn') ?? false;
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
