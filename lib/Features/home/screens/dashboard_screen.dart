import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/agent/screens/agent_screen.dart';
import 'package:expense_manager/Features/product/screens/product_screen.dart';
import 'package:expense_manager/Features/transactions/screens/add_transaction_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/global_variables.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/profile_controller.dart';
import '../../customer/screens/view_customers_screen.dart';
import '../../payment/screens/add_advance_screen.dart';
import '../../payment/screens/add_payment_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => profileController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : profileController.userData.isBlank!
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        "No data available",
                        style: lightTextTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: AppBar(
                      flexibleSpace: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          SlideInDown(
                            child: Container(
                              height: 55,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Hello ${profileController.userData.value?.ownerName?.split(' ').first ?? "User"}!',
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        profileController.greetingMessage.value,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.transparent, // Colors.black26,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return ZoomIn(
                                child: GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      Get.to(() => const AgentScreen());
                                    } else if (index == 1) {
                                      Get.to(() => const ProductScreen());
                                    } else if (index == 2) {
                                      Get.to(
                                          () => const AddTransactionScreen());
                                    } else if (index == 3) {
                                      Get.to(() => const CustomersScreen());
                                    } else if (index == 4) {
                                      Get.to(() => const AddPaymentScreen());
                                    } else if (index == 5) {
                                      Get.to(() => const AddAdvanceScreen());
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 15, 15, 15),
                                        alignment: Alignment.center,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: primaryColor3,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2,
                                              spreadRadius: 0.5,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              offset: const Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                  style: lightTextTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons
                                                    .keyboard_arrow_right_outlined,
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
                      ],
                    ),
                  ),
                ),
    );
  }
}
