import 'package:flutter/material.dart';

import '../color/colors.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: background,
        strokeWidth: 2.6,
        backgroundColor: primaryColor,
        valueColor: AlwaysStoppedAnimation<Color>(background),
      ),
    );
  }
}
