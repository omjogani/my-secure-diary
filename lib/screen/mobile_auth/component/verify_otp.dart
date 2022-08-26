import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/screen/home/main_screen.dart';
import 'package:diary/screen/mobile_auth/component/num_pad.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/set_new_mpin/set_new_mpin.dart';
import 'package:diary/screen/user_details/user_details.dart';
import 'package:diary/screen/verify_mpin/verify_mpin.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;
  final String verificationID;
  final AuthBase auth;

  const VerifyPhone({
    Key? key,
    required this.phoneNumber,
    required this.verificationID,
    required this.auth,
  }) : super(key: key);

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String code = "";
  Auth auth = Auth();
  bool isLoading = false;

  Future checkUserNameForNewUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        String name = snapshot.data()?["name"];
        String mpin = snapshot.data()?["mpin"];
        if (name == 'User') {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetails(
                auth: widget.auth,
                navigationRoute: mpin == "0000" ? "SetMPin": "MainScreen",
              ),
            ),
          );
        } else if (mpin == "0000") {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetNewMPin(
                auth: auth,
                isNavigatingMainScreen: true,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyMPin(
                auth: auth,
                whereToNavigate: "MainScreen",
              ),
            ),
          );
        }
      });
    });
  }

  void signInAndNavigate() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response =
          await auth.signInWithPhoneNumber(widget.verificationID, code);
      await checkUserNameForNewUser();
    } catch (e) {
      print(e.toString());
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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        title: const Text(
          "Verify phone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Code is sent to " + widget.phoneNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF818181),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCodeNumberBox(
                            code.length > 0 ? code.substring(0, 1) : ""),
                        buildCodeNumberBox(
                            code.length > 1 ? code.substring(1, 2) : ""),
                        buildCodeNumberBox(
                            code.length > 2 ? code.substring(2, 3) : ""),
                        buildCodeNumberBox(
                            code.length > 3 ? code.substring(3, 4) : ""),
                        buildCodeNumberBox(
                            code.length > 4 ? code.substring(4, 5) : ""),
                        buildCodeNumberBox(
                            code.length > 5 ? code.substring(5, 6) : ""),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => isLoading ? () {} : signInAndNavigate(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFDC3D),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
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
                              : const Text(
                                  "Verify",
                                  style: TextStyle(
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
                if (value != -1) {
                  if (code.length < 6) {
                    code = code + value.toString();
                  }
                } else if (code.length > 0) {
                  code = code.substring(0, code.length - 1);
                }
              });
            },
          ),
        ],
      )),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return SizedBox(
      width: 45,
      height: 45,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F5FA),
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
          child: Text(
            codeNumber,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
      ),
    );
  }
}
