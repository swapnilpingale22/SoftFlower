import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 800),
      content: Text(
        content,
        style: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      backgroundColor: primaryColor3,
    ),
  );
}
