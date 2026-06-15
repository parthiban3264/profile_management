import 'package:flutter/material.dart';

import '../color/colors.dart';

class SnackBarMessenger {
  void showSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(20),

        backgroundColor: backgroundColor,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: text,
                  fontSize: 16,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
