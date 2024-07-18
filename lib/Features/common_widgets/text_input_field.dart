import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldInput extends StatelessWidget {
  var suffixcon;

  TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.labelText = "",
    required this.textInputType,
    this.isPass = false,
    required this.suffixcon,
  });

  final TextEditingController textEditingController;
  bool isPass;
  final String hintText;
  final String labelText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    var inputBorder =
        const OutlineInputBorder(borderSide: BorderSide(color: primaryColor1));
    var focusedinputBorder =
        const OutlineInputBorder(borderSide: BorderSide(color: primaryColor3));

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: mobileBackgroundColor,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        // labelText: labelText,
        labelStyle: const TextStyle(fontSize: 14),
        border: inputBorder,
        focusedBorder: focusedinputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: suffixcon,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: const TextStyle(color: textColor),
    );
  }
}
