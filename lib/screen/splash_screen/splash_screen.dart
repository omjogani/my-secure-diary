import 'dart:math';
import 'package:diary/constant.dart';
import 'package:flutter/material.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/screen/wrapper.dart';
import 'package:diary/screen/splash_screen/components/splashscreen.dart';


class Splash extends StatelessWidget {
  const Splash({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    List<Color> currentSelectedGradient = kGradientColors[Random().nextInt(10)];
    return SplashScreen(
      title: const Text(
        "My Secure\nDiary",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      seconds: 3,
      shadowColor: currentSelectedGradient.first,
      gradientBackground: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: currentSelectedGradient,
      ),
      image: Image.asset(
        "assets/images/walt.png",
      ),
      styleTextUnderTheLoader: const TextStyle(),
      photoSize: 100,
      loaderColor: Colors.white,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      navigateAfterSeconds: Wrapper(
        auth: Auth(),
      ),
    );
  }
}
