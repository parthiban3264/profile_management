import 'package:flutter/material.dart';
import 'package:profile_management/color/colors.dart';

import '../views/settings/setting_screen.dart';

class CustomAppbar extends StatefulWidget {
  final String title;
  final bool pop;
  final bool setting;
  final bool drawer;
  final VoidCallback? onMenuTap;
  const CustomAppbar({
    super.key,
    required this.title,
    required this.pop,
    required this.setting,
    required this.drawer,
    this.onMenuTap,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      title: Text(
        widget.title,
        style: TextStyle(
          color: background,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      shadowColor: Colors.transparent,
      leading: widget.drawer
          ? IconButton(
              onPressed: widget.onMenuTap,
              icon: Icon(Icons.menu_open, color: background, size: 30),
            )
          : widget.pop
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: background),
            )
          : null,
      actions: widget.setting
          ? [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingScreen()),
                  );
                },
                icon: Icon(Icons.settings, color: background),
              ),
            ]
          : [],
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
    );
  }
}
