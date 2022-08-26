import 'package:diary/constant.dart';
import 'package:diary/encryption/encryption.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/screen/home/main_screen.dart';
import 'package:diary/screen/mobile_auth/component/num_pad.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/screen/user_details/components/title_and_details.dart';
import 'package:diary/screen/verify_mpin/components/mpin_widget.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/database_service.dart';
import 'package:diary/widgets/custom_showdialog.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNewMPin extends StatefulWidget {
  const SetNewMPin({
    Key? key,
    required this.auth,
    required this.isNavigatingMainScreen,
  }) : super(key: key);
  final AuthBase auth;
  final bool isNavigatingMainScreen;

  @override
  _SetNewMPinState createState() => _SetNewMPinState();
}

class _SetNewMPinState extends State<SetNewMPin> {
  MPinController mPinController = MPinController();
  late SharedPreferences preferences;
  int currentIndexTheme = -1;
  String initialMPin = '';
  String confirmMpin = '';
  bool isFirstMPin = true;
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
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: Stack(
          children: <Widget>[
            Background(listOfColors: kBackgroundShadowColor[currentIndexTheme]),
            Padding(
              padding: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TitleAndDetails(
                    titleString: isFirstMPin ? "Set MPIN" : "Confirm MPIN",
                  ),
                  MPinWidget(
                    pinLength: 4,
                    controller: mPinController,
                    onCompleted: (mPin) async {
                      if (isFirstMPin) {
                        initialMPin = mPin;
                        setState(() {
                          isFirstMPin = false;
                        });
                        mPinController.clearInput();
                      } else {
                        confirmMpin = mPin;
                      }
                      if (initialMPin != '' && confirmMpin != '') {
                        if (initialMPin == confirmMpin) {
                          Encryption enc =
                              Encryption(messageToBeEncrypted: initialMPin);
                          final String mPinToBeStored =
                              enc.encryptMe(int.parse(initialMPin[3]));
                          try {
                            await DatabaseService(
                                    uid: widget.auth.currentUser!.uid)
                                .updateMPin(mPinToBeStored);
                            if (widget.isNavigatingMainScreen) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(auth: widget.auth),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              CustomShowDialog customShowDialog =
                                  CustomShowDialog();
                              customShowDialog.showCustomDialog(
                                context,
                                "Congrats!! Your MPIN is updated!!",
                                "OK",
                              );
                              
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {
                          setState(() {
                            initialMPin = '';
                            confirmMpin = '';
                            isFirstMPin = true;
                          });
                          mPinController.clearInput();
                          widget.auth.showSnackbar(
                              context, "MPIN is not matched, Try again");
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        initialMPin = '';
                        confirmMpin = '';
                        isFirstMPin = true;
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
          ],
        ),
      ),
    );
  }
}
