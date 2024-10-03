import 'package:expense_manager/Features/auth/controller/auth.dart';
import 'package:expense_manager/Features/auth/screens/signup_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/custom_rounded_button.dart';
import '../../company/screens/add_company.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
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
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const CircleAvatar(
                          minRadius: 53,
                          backgroundColor: primaryColor3,
                          child: CircleAvatar(
                            minRadius: 50,
                            backgroundColor: mobileBackgroundColor,
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: primaryColor3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${profileController.userData.value?.email}',
                          style: lightTextTheme.headlineMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        profileController.userData.value?.userType == 'admin'
                            ? Text(
                                'Admin',
                                style: lightTextTheme.headlineMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),
                        profileController.userData.value?.userType == 'admin'
                            ? CustomRoundedButton(
                                text: 'Add Users',
                                color: primaryColor3,
                                onTap: () {
                                  Get.to(() => const SignUpScreen());
                                },
                              )
                            : const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        CustomRoundedButton(
                          text: 'Log out',
                          color: mobileBackgroundColor,
                          textColor: textColor,
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Alert'),
                                content: const Text(
                                    'Do you really want to Log Out?'),
                                actions: [
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      await Auth().signOut();
                                      showSnackBar('Signed Out successfully!',
                                          Get.context!);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('No'),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        // CustomRoundedButton(
                        //   text: 'Delete Account',
                        //   color: mobileBackgroundColor,
                        //   textColor: textColor,
                        //   onTap: () {
                        //     showCupertinoDialog(
                        //       context: context,
                        //       builder: (context) => CupertinoAlertDialog(
                        //         title: const Text('Alert'),
                        //         content: const Text(
                        //             'Do you really want to Delete your account?'),
                        //         actions: [
                        //           CupertinoDialogAction(
                        //             isDestructiveAction: true,
                        //             child: const Text('Yes'),
                        //             onPressed: () async {
                        //               await Auth().deleteUserAccount();
                        //               showSnackBar(
                        //                   'Account deleted!', Get.context!);
                        //             },
                        //           ),
                        //           CupertinoDialogAction(
                        //             child: const Text('No'),
                        //             onPressed: () => Get.back(),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                        const SizedBox(height: 10),
                        const Spacer(),
                        const Divider(
                          color: primaryColor2,
                          thickness: 1.5,
                        ),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: primaryColor3,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: whiteColor,
                            ),
                          ),
                          title: const Text("Company"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(() => const AddCompanyScreen());
                          },
                        ),
                        // ListTile(
                        //   leading: Container(
                        //     padding: const EdgeInsets.all(5),
                        //     decoration: const BoxDecoration(
                        //       color: primaryColor3,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(4),
                        //       ),
                        //     ),
                        //     child: const Icon(
                        //       Icons.help_outline_rounded,
                        //       color: whiteColor,
                        //     ),
                        //   ),
                        //   title: const Text("FAQ's"),
                        //   trailing: const Icon(Icons.arrow_forward_ios),
                        // ),
                        // ListTile(
                        //   leading: Container(
                        //     padding: const EdgeInsets.all(5),
                        //     decoration: const BoxDecoration(
                        //       color: primaryColor3,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(4),
                        //       ),
                        //     ),
                        //     child: const Icon(
                        //       Icons.receipt_long_outlined,
                        //       color: whiteColor,
                        //     ),
                        //   ),
                        //   title: const Text("Terms & Conditions"),
                        //   trailing: const Icon(Icons.arrow_forward_ios),
                        // ),
                      ],
                    )),
                  ),
      ),
    );
  }
}
