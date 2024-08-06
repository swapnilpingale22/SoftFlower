// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomRoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final double height;
  final double width;
  const CustomRoundedButton({
    super.key,
    required this.text,
    this.onTap,
    this.color = primaryColor3,
    this.textColor = whiteColor,
    this.isLoading = false,
    this.height = 50,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              color: primaryColor3,
              width: 2,
            ),
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
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
