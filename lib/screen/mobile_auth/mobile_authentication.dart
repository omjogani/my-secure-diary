import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/screen/mobile_auth/component/num_pad.dart';
import 'package:diary/screen/mobile_auth/component/verify_otp.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/widgets/custom_showdialog.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileAuthentication extends StatefulWidget {
  const MobileAuthentication({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  _MobileAuthenticationState createState() => _MobileAuthenticationState();
}

class _MobileAuthenticationState extends State<MobileAuthentication> {
  String phoneNumber = "";
  String phoneNumberToBeDisplayed = "";
  String verificationIDFinal = "";
  String buttonMessage = "Send";
  bool isLoading = false;

  Auth auth = Auth();

  bool isValidPhoneNumber(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      auth.showSnackbar(context, 'Please Enter Mobile Number...');
      setState(() {
        isLoading = false;
      });
      return false;
    } else if (!regExp.hasMatch(value)) {
      auth.showSnackbar(context, 'Invalid!! Please Enter Valid Mobile Number');
      setState(() {
        isLoading = false;
      });
      return false;
    }
    return true;
  }

  Future<bool> _verifyAndOTPRedirect(String _phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(context, "+91 $_phoneNumber", setData);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _sendToServer() async {
    setState(() {
      isLoading = true;
    });
    bool isValid = isValidPhoneNumber(phoneNumber);

    if (isLoading && isValid) {
      bool? response = await _verifyAndOTPRedirect(phoneNumber);
      print("RESPONSE: $response");
      if (response) {
        setState(() {
          buttonMessage = "Continue";
        });
        if (verificationIDFinal != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhone(
                phoneNumber: phoneNumber,
                verificationID: verificationIDFinal,
                auth: widget.auth,
              ),
            ),
          );
        }
      } else {
        auth.showSnackbar(context, "Something went Wrong! Try Again...");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (verificationIDFinal != "") {
      setState(() {
        isLoading = false;
        buttonMessage = "Continue";
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Phone Authentication",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        elevation: 0,
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 130,
                      child: Image.asset('assets/images/calender.png'),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                      child: Text(
                        "You'll receive 6 Digit code for Verification.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Enter your phone",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AutoSizeText(
                            phoneNumberToBeDisplayed,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isLoading ? {} : _sendToServer(),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFDC3D),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 25.0,
                                spreadRadius: 1,
                                offset: Offset(0.0, 0.75),
                              )
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : Text(
                                    buttonMessage,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NumericPad(
              onNumberSelected: (value) {
                setState(() {
                  if (value != -1 && phoneNumber.length < 10) {
                    if (phoneNumber.length == 5) {
                      phoneNumberToBeDisplayed += " ";
                    }
                    phoneNumber = phoneNumber + value.toString();
                    phoneNumberToBeDisplayed =
                        phoneNumberToBeDisplayed + value.toString();
                  } else if (phoneNumber.length > 0 && value == -1) {
                    phoneNumber =
                        phoneNumber.substring(0, phoneNumber.length - 1);
                    phoneNumberToBeDisplayed =
                        phoneNumberToBeDisplayed.substring(
                            0,
                            phoneNumber.length == 5
                                ? phoneNumberToBeDisplayed.length - 2
                                : phoneNumberToBeDisplayed.length - 1);
                  }
                });
              },
            ),
          ],
        )),
      ),
    );
  }

  void setData(verificationID) {
    setState(() {
      verificationIDFinal = verificationID;
    });
  }
}
