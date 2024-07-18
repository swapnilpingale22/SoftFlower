// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureTextValue;
  final int maxLines;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.name,
    this.obscureTextValue = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureTextValue,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor3,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
      style: lightTextTheme.bodyMedium!.copyWith(),
    );
  }
}
