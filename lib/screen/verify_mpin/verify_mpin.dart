import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/constant.dart';
import 'package:diary/encryption/encryption.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/screen/display_information/display_information.dart';
import 'package:diary/screen/home/main_screen.dart';
import 'package:diary/screen/lock_app/lock_app.dart';
import 'package:diary/screen/mobile_auth/component/num_pad.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/verify_mpin/components/mpin_widget.dart';
import 'package:diary/screen/set_new_mpin/set_new_mpin.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/screen/user_details/components/title_and_details.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/database_service.dart';
import 'package:diary/widgets/custom_snackbar.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyMPin extends StatefulWidget {
  const VerifyMPin({
    Key? key,
    required this.auth,
    required this.whereToNavigate,
  }) : super(key: key);
  final AuthBase auth;
  final String whereToNavigate;

  @override
  State<VerifyMPin> createState() => _VerifyMPinState();
}

class _VerifyMPinState extends State<VerifyMPin> {
  MPinController mPinController = MPinController();
  bool isUnlocked = false;
  String enteredMPin = '';
  bool isLoading = false;
  int currentIndexTheme = -1;
  late SharedPreferences preferences;
  int invalidMPinCount = 0;

  void verifyTheMPIN(String enteredMpin) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        String encryptedMPin = snapshot.data()?["mpin"];
        if (encryptedMPin != '') {
          Encryption decryptionHelper =
              Encryption(messageToBeEncrypted: encryptedMPin);
          final String originalMPinFromDB =
              decryptionHelper.decryptMe(int.parse(enteredMpin[3]));
          print("OriginalMPinFromDB :: $originalMPinFromDB");
          if (originalMPinFromDB == "0000") {
            isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetNewMPin(
                  auth: widget.auth,
                  isNavigatingMainScreen: true,
                ),
              ),
            );
          } else if (originalMPinFromDB != '') {
            if (originalMPinFromDB == enteredMpin) {
              isLoading = false;
              if (widget.whereToNavigate == "MainScreen") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(auth: widget.auth),
                  ),
                );
              } else if (widget.whereToNavigate == "UpdateMPin") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetNewMPin(
                      auth: widget.auth,
                      isNavigatingMainScreen: false,
                    ),
                  ),
                );
              } else if (widget.whereToNavigate == "PasswordSection") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayInformation(
                      auth: widget.auth,
                      title: "Passwords",
                      isPasswordSection: true,
                      keyToEncrypt: originalMPinFromDB,
                    ),
                  ),
                );
              } else if (widget.whereToNavigate == "LockMyDiary") {
                DatabaseService(uid: widget.auth.currentUser!.uid)
                    .updateLockedStatus(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LockAppScreen(isSuspicious: false),
                  ),
                );
              }
            } else {
              isLoading = false;
              setState(() {
                invalidMPinCount++;
              });
              if (invalidMPinCount >= 3) {
                DatabaseService(uid: widget.auth.currentUser!.uid).updateLockedStatus(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LockAppScreen(isSuspicious: true),
                  ),
                );
              }
              customSnackBar(
                context,
                "Invalid $invalidMPinCount/3 Attempt",
                Colors.red.shade200,
                const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                true,
              );
              mPinController.notifyWrongInput();
            }
          }
        }
      });
    });
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
    }
    setState(() {
      currentIndexTheme = getCurrentIndex!;
    });
  }

  @override
  void initState() {
    sharedPreferencesInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
    if (currentIndexTheme == -1) {
      return const FullScreenLoading(
          message: "Loading...", simpleLoadingAnimation: true);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(listOfColors: kBackgroundShadowColor[currentIndexTheme]),
          Padding(
            padding: const EdgeInsets.only(
              top: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const TitleAndDetails(
                  titleString: "Verify MPIN",
                ),
                MPinWidget(
                  pinLength: 4,
                  controller: mPinController,
                  onCompleted: (mPin) async {
                    setState(() {
                      isLoading = true;
                    });
                    print("You have entered -> $mPin");
                    enteredMPin = mPin;
                    verifyTheMPIN(enteredMPin);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      enteredMPin = '';
                    });
                    mPinController.clearInput();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 25.0,
                          spreadRadius: 1,
                          offset: Offset(0.0, 0.75),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          "Reset",
                          style: subtitleTextStyleBlack,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                NumericPad(onNumberSelected: (int pressedNumber) {
                  if (pressedNumber == -1) {
                    mPinController.delete();
                  } else {
                    mPinController.addInput("$pressedNumber");
                  }
                }),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SpinKitFadingCircle(
                            color: Colors.white,
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            "Validating...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
