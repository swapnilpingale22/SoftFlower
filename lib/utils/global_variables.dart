import 'package:expense_manager/Features/home/screens/dashboard_screen.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';

import '../Features/auth/screens/profile_screen.dart';
import '../Features/customer/screens/view_customers_screen.dart';
import '../Features/home/screens/all_reports_screen.dart';

List<Widget> homeScreenItems = [
  const DashboardScreen(),
  const AllReportsScreen(),
  const ProfileScreen(),
  const CustomersScreen(),
];

List<String> buttonTitles = [
  "Farmers",
  "Flowers",
  "Patti",
  "Customer",
];
List<String> allReportsbuttonTitles = [
  "All Patti Reports",
  "Month Business",
];

List<String> buttonIcons = [
  "assets/images/agent.png",
  "assets/images/products.png",
  "assets/images/trade.png",
  "assets/images/company.png",
  "assets/images/transaction (1).png",
];

List<String> allReportsbuttonIcons = [
  "assets/images/transaction (1).png",
  "assets/images/transaction (1).png",
];

class CommingSoonScreen extends StatelessWidget {
  const CommingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/work-in-progress.png',
              height: 180,
            ),
            const SizedBox(height: 50),
            Text(
              'This feature is in development. Stay tuned for more features!',
              style: lightTextTheme.headlineMedium?.copyWith(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
