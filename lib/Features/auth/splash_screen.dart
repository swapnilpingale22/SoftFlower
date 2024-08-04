import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/auth/login_screen.dart';
import 'package:expense_manager/Features/home/screens/botttom_bar.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/images/splash_bg_video.hevc.mp4')
          ..initialize().then((_) {
            // _videoController.play();
            // _startFadeIn();
            setState(() {});
          });
    _videoController.setLooping(false);
    _videoController.play();
    _startFadeIn();
    navigateToNext();
  }

  navigateToNext() {
    Timer(
      const Duration(milliseconds: 5000),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => streamBuilderMethod(),
          ),
        );
      },
    );
  }

  void _startFadeIn() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: _videoController.value.isInitialized
                    ? VideoPlayer(_videoController)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 50,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: ZoomIn(
                duration: const Duration(seconds: 2),
                child: Text(
                  'SoftFlower',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.white.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<User?> streamBuilderMethod() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {}
        return const LoginScreen();
      },
    );
  }
}
