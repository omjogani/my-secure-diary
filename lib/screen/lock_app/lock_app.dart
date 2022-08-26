import 'package:diary/widgets/custom_showdialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LockAppScreen extends StatelessWidget {
  const LockAppScreen({
    Key? key,
    required this.isSuspicious,
  }) : super(key: key);
  final bool isSuspicious;

  @override
  Widget build(BuildContext context) {
    const String suspiciousText =
        "Suspicious Activity Detected!! Please Contact to Developer...";
    const String notSuspiciousText =
        "Diary is Locked!! Please Contact to Developer...";
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
              "assets/lottie/locked_app.json",
            ),
            const Text(
              "Diary is Locked,\nYou can not proceed further.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            Text(
              isSuspicious ? suspiciousText : notSuspiciousText,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
