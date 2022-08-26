import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/encryption/encryption.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/lock_app/lock_app.dart';
import 'package:diary/screen/mobile_auth/mobile_authentication.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/set_new_mpin/set_new_mpin.dart';
import 'package:diary/screen/user_details/user_details.dart';
import 'package:diary/screen/verify_mpin/verify_mpin.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String navigationStatus = "";

  late SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    checkForDarkMode();
    sharedPreferencesInitialization();
    checkNavigation();
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      addThemeToSharedPreferences();
    }
  }

  Future checkForDarkMode() async {
    preferences = await SharedPreferences.getInstance();
    bool? isDarkMode = preferences.getBool("isDarkMode");
    if (isDarkMode == null) {
      preferences.setBool("isDarkMode", false);
      isDarkMode = false;
    }
    print("isDarkMode $isDarkMode");
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.toggleTheme(isDarkMode);
  }

  void addThemeToSharedPreferences() {
    preferences.setInt("themeIndex", 0);
  }

  void checkNavigation() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (snapshot) {
          String userNameFromDB = snapshot.data()?['name'];
          String mPinFromDB = snapshot.data()?["mpin"];
          bool isLocked = snapshot.data()?["isLocked"];
          if (isLocked) {
            setState(() {
              navigationStatus = "Locked";
            });
          } else if (userNameFromDB == "" || userNameFromDB == "User") {
            setState(() {
              navigationStatus = "UserDetails";
            });
          } else if (mPinFromDB == "" || mPinFromDB == "0000") {
            setState(() {
              navigationStatus = "SetMPin";
            });
          } else {
            return const FullScreenLoading(
              message: "Authorizing...",
              simpleLoadingAnimation: true,
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentConnectionStatus =
        Provider.of<InternetConnectivityStatus?>(context);
    if (currentConnectionStatus == null) {
      return const FullScreenLoading(
        message: "Checking Internet Connection...",
        simpleLoadingAnimation: false,
      );
    }
    if (currentConnectionStatus == InternetConnectivityStatus.offline) {
      return const NoInternetScreen();
    }
    return StreamBuilder<User?>(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return MobileAuthentication(auth: widget.auth);
          }

          if (navigationStatus == "Locked") {
            return const LockAppScreen(isSuspicious: false);
          } else if (navigationStatus == "UserDetails") {
            return UserDetails(auth: widget.auth, navigationRoute: "Pop");
          } else if (navigationStatus == "SetMPin") {
            return SetNewMPin(auth: widget.auth, isNavigatingMainScreen: true);
          } else {
            return VerifyMPin(
              auth: widget.auth,
              whereToNavigate: "MainScreen",
            );
          }
        } else {
          return const FullScreenLoading(
            message: "Authorizing...",
            simpleLoadingAnimation: true,
          );
        }
      },
    );
  }
}
