// ignore_for_file: use_build_context_synchronously

import 'package:expense_manager/Features/auth/screens/login_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../common_widgets/text_input_field.dart';
import '../../home/screens/botttom_bar.dart';
import '../controller/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isSeen = true;
  bool _isObscure = true;
  var eyeFill = const Icon(CupertinoIcons.eye_fill, color: Colors.grey);
  var eyeSlashFill = const Icon(CupertinoIcons.eye_slash_fill);

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Auth().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Get.offAll(() => const HomeScreen());
      showSnackBar('Account Created Successfully! Welcome', context);
    }
  }

  void navigateToLogIn() {
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const SizedBox(height: 65),
                const SizedBox(height: 25),
                const SizedBox(height: 25),
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  suffixcon: null,
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 25),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter new password',
                  labelText: "Password",
                  textInputType: TextInputType.visiblePassword,
                  isPass: _isObscure ? true : false,
                  suffixcon: IconButton(
                    tooltip: 'Show password',
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                        _isSeen = !_isSeen;
                      });
                    },
                    icon: _isSeen ? eyeFill : eyeSlashFill,
                  ),
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    height: 60.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: primaryColor3,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Already have an account?    '),
                    ),
                    InkWell(
                      onTap: navigateToLogIn,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
