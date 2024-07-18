// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.color = primaryColor3,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                color: primaryColor,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
    );
  }
}
