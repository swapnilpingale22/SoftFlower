import 'dart:ui';

import 'package:expense_manager/Features/auth/controller/auth.dart';
import 'package:expense_manager/Features/common_widgets/text_input_field.dart';
import 'package:expense_manager/Features/home/screens/botttom_bar.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSeen = true;
  bool _isObscure = true;
  var eyeFill = const Icon(CupertinoIcons.eye_fill, color: Colors.grey);
  var eyeSlashFill = const Icon(CupertinoIcons.eye_slash_fill);
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/images/login_bg_video.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
    _videoController.setLooping(true);
    _videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUSer() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Auth().logInUSer(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      showSnackBar(res, Get.context!);
    } else {
      showSnackBar(res, Get.context!);
      Navigator.of(Get.context!).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      showSnackBar('Welcome', Get.context!);
    }
  }

  // void navigateToSignUp() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const SignUpScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: _videoController.value.isInitialized
                        ? VideoPlayer(_videoController)
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 150),
                      // Flexible(flex: 2, child: Container()),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 65),
                      TextFieldInput(
                        textEditingController: _emailController,
                        hintText: 'Email',
                        labelText: 'Email',
                        textInputType: TextInputType.emailAddress,
                        suffixcon: null,
                      ),
                      const SizedBox(height: 25),
                      TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: 'Password',
                        labelText: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        isPass: _isObscure ? true : false,
                        suffixcon: IconButton(
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
                        onTap: logInUSer,
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0.4),
                                child: _isLoading
                                    ? const Center(
                                        child: CupertinoActivityIndicator(
                                          color: primaryColor,
                                        ),
                                      )
                                    : const Text(
                                        'Log In',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
