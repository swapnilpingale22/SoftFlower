import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/transactions/screens/reports_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/global_variables.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../transactions/screens/month_transaction_screen.dart';

class AllReportsScreen extends StatefulWidget {
  const AllReportsScreen({super.key});

  @override
  State<AllReportsScreen> createState() => _AllReportsScreenState();
}

class _AllReportsScreenState extends State<AllReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: FadeInLeft(
          child: Text(
            'Patti Reports',
            style: lightTextTheme.headlineMedium?.copyWith(
              fontSize: 20,
            ),
          ),
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: 2,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return ZoomIn(
                child: GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Get.to(() => const Reports());
                    } else if (index == 1) {
                      Get.to(() => const MonthTransactionScreen());
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryColor3,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 0.5,
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            allReportsbuttonIcons[index],
                            height: 55,
                            width: 55,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            allReportsbuttonTitles[index],
                            textAlign: TextAlign.center,
                            style: lightTextTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
