import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../color/colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool isPassword = false,
  void Function()? onTap,
  List<TextInputFormatter>? formatter,
  Widget? suffixIcon,
  void Function(String)? onChanged,
  bool isObscure = true,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    textAlign: TextAlign.start,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16),
      prefixIcon: Icon(icon, color: primaryColor),
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    obscureText: isPassword && isObscure,
    onChanged: onChanged,
    onTap: onTap,
    inputFormatters: formatter,
  );
}
