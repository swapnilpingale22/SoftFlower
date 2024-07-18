import 'package:expense_manager/utils/global_variables.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: const CommingSoonScreen(),
    );
  }
}
