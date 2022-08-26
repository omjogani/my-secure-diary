import 'package:diary/constant.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/screen/home/main_screen.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/set_new_mpin/set_new_mpin.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/screen/user_details/components/capture_name_and_continue.dart';
import 'package:diary/screen/user_details/components/title_and_details.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/database_service.dart';
import 'package:diary/widgets/custom_showdialog.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({
    Key? key,
    required this.auth,
    required this.navigationRoute,
  }) : super(key: key);
  final AuthBase auth;
  final String navigationRoute;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  late SharedPreferences preferences;
  int currentIndexTheme = -1;
  late String name;
  bool _validate = false;

  String? _validateName(String nameStr) {
    nameStr = nameStr.trim();
    String pattern = r'/^[a-z ,-]+$/i';
    RegExp regExp = RegExp(pattern);
    print("name : $nameStr");
    if (nameStr.isEmpty) {
      return "Enter Name";
    } else if (!regExp.hasMatch(nameStr) && nameStr.length <= 1) {
      return "Invalid Name";
    }
    return null;
  }

  void _updateNameAndProcess() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      name = _nameController.text.trim();
      try {
        await DatabaseService(uid: widget.auth.currentUser!.uid)
            .updateName(name);
        print("Clear at this point");
        if (widget.navigationRoute == "SetMPin") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetNewMPin(
                auth: widget.auth,
                isNavigatingMainScreen: true,
              ),
            ),
          );
        } else if (widget.navigationRoute == "Pop") {
          Navigator.pop(context);
          CustomShowDialog customShowDialog = CustomShowDialog();
          print("hello There");
          customShowDialog.showCustomDialog(
            context,
            "Congrats!! Your name is updated!!",
            "OK",
          );
        } else if (widget.navigationRoute == "MainScreen") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                auth: widget.auth,
              ),
            ),
          );
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
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
      body: Stack(
        children: <Widget>[
          Background(listOfColors: kBackgroundShadowColor[currentIndexTheme]),
          Padding(
            padding: const EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
              bottom: 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const TitleAndDetails(
                  titleString: "Please Enter Your Name.",
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Form(
                  key: _key,
                  autovalidateMode: _validate
                      ? AutovalidateMode.always
                      : AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      CustomFullWidthTextField(
                        hintText: "Your Name",
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (str) => _validateName(str!),
                        onSaved: (str) {
                          name = str!;
                        },
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      CustomFullWidthButton(
                        buttonText: "Continue",
                        buttonColor: kBackgroundShadowColor[currentIndexTheme].first,
                        onTap: () => _updateNameAndProcess(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
