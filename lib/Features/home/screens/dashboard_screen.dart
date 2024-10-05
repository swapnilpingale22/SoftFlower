import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/agent/screens/agent_screen.dart';
import 'package:expense_manager/Features/product/screens/product_screen.dart';
import 'package:expense_manager/Features/transactions/screens/add_transaction_screen.dart';
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
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    CircleAvatar(
                      maxRadius: 20,
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/images/man.png"),
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello Sandip!',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.transparent, // Colors.black26,
                      maxRadius: 20,
                      child: CircleAvatar(
                        maxRadius: 19,
                        backgroundColor: mobileBackgroundColor,
                        child: Image.asset(
                          "assets/images/menu-button.png",
                          color: Colors.black45,
                          height: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return ZoomIn(
                  child: GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Get.to(() => const AgentScreen());
                      } else if (index == 1) {
                        Get.to(() => const ProductScreen());
                      } else if (index == 2) {
                        Get.to(() => const AddTransactionScreen());
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 25, 15, 5),
                          alignment: Alignment.center,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Image.asset(
                                    buttonIcons[index],
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Text(
                                    buttonTitles[index],
                                    textAlign: TextAlign.left,
                                    style: lightTextTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black38,
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // GridView.builder(
          //   shrinkWrap: true,
          //   itemCount: 3,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2),
          //   itemBuilder: (context, index) {
          //     return ZoomIn(
          //       child: GestureDetector(
          //         onTap: () {
          //           if (index == 0) {
          //             Get.to(() => const AgentScreen());
          //           } else if (index == 1) {
          //             Get.to(() => const ProductScreen());
          //           } else if (index == 2) {
          //             Get.to(() => const AddTransactionScreen());
          //           }
          //           // else if (index == 3) {
          //           //   Get.to(() => const Reports());
          //           // }
          //           // else if (index == 4) {
          //           //   Get.to(() => const AddCompanyScreen());
          //           // }
          //         },
          //         child: Container(
          //           margin: const EdgeInsets.all(15),
          //           width: 100,
          //           height: 100,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8),
          //             color: primaryColor3,
          //             boxShadow: [
          //               BoxShadow(
          //                 blurRadius: 2,
          //                 spreadRadius: 0.5,
          //                 color: Colors.grey.withOpacity(0.5),
          //                 offset: const Offset(3, 3),
          //               ),
          //             ],
          //           ),
          //           child: Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Image.asset(
          //                   buttonIcons[index],
          //                   height: 55,
          //                   width: 55,
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Text(
          //                   buttonTitles[index],
          //                   textAlign: TextAlign.center,
          //                   style: lightTextTheme.bodyMedium?.copyWith(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 20,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
