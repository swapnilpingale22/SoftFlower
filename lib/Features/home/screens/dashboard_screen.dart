import 'package:expense_manager/Features/agent/screens/add_agent_screen.dart';
import 'package:expense_manager/Features/auth/controller/auth.dart';
import 'package:expense_manager/Features/company/screens/add_company.dart';
import 'package:expense_manager/Features/product/screens/add_product_screen.dart';
import 'package:expense_manager/Features/transactions/screens/add_transaction_screen.dart';
import 'package:expense_manager/Features/transactions/screens/reports_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/global_variables.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: Auth().signOut,
            icon: const Icon(
              Icons.power_settings_new,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       height: 100,
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         shrinkWrap: true,
          //         itemCount: 3,
          //         itemBuilder: (context, index) {
          //           return GestureDetector(
          //             onTap: () {
          //               if (index == 0) {
          //                 Get.to(() => const AddAgentScreen());
          //               } else if (index == 1) {
          //                 Get.to(() => const AddProductScreen());
          //               } else if (index == 2) {
          //                 Get.to(() => const AddTransactionScreen());
          //               }
          //             },
          //             child: Container(
          //               margin: const EdgeInsets.all(15),
          //               width: 100,
          //               height: 100,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8),
          //                 color: primaryColor3,
          //                 boxShadow: [
          //                   BoxShadow(
          //                     blurRadius: 2,
          //                     spreadRadius: 0.5,
          //                     color: Colors.grey.withOpacity(0.5),
          //                     offset: const Offset(3, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   buttonTitles[index],
          //                   textAlign: TextAlign.center,
          //                   style: lightTextTheme.bodyMedium?.copyWith(
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Get.to(() => const AddAgentScreen());
                  } else if (index == 1) {
                    Get.to(() => const AddProductScreen());
                  } else if (index == 2) {
                    Get.to(() => const AddTransactionScreen());
                  } else if (index == 3) {
                    Get.to(() => const Reports());
                  } else if (index == 4) {
                    Get.to(() => const AddCompanyScreen());
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
                          buttonIcons[index],
                          height: 55,
                          width: 55,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          buttonTitles[index],
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
              );
            },
          )
        ],
      ),
    );
  }
}
