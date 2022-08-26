import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/constant.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/display_information/display_information.dart';
import 'package:diary/screen/home/components/main_screen_box.dart';
import 'package:diary/screen/lock_app/lock_app.dart';
import 'package:diary/screen/verify_mpin/verify_mpin.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/widgets/custom_showdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.auth,
    required this.currentThemeIndex,
  }) : super(key: key);
  final AuthBase auth;
  final int currentThemeIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            TopNavBar(
                auth: widget.auth, currentThemeIndex: widget.currentThemeIndex),
            const SizedBox(height: 20.0),
            MainOpenWindowSection(auth: widget.auth),
          ],
        ),
      ),
    );
  }
}

class TopNavBar extends StatefulWidget {
  const TopNavBar({
    Key? key,
    required this.auth,
    required this.currentThemeIndex,
  }) : super(key: key);
  final AuthBase auth;
  final int currentThemeIndex;

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadNameFromDB();
  }

  void _loadNameFromDB() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        name = snapshot.data()?['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              "Hello,$name",
              overflow: TextOverflow.ellipsis,
              style: buttonTextStyle.copyWith(fontSize: 27.0),
              maxLines: 1,
            ),
          ),
          GestureDetector(
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Container(
              height: 42.0,
              width: 42.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: kBackgroundShadowColor[widget.currentThemeIndex][0]
                        .withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 12.0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MainOpenWindowSection extends StatelessWidget {
  const MainOpenWindowSection({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MainScreenBox(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayInformation(
                  auth: auth,
                  title: "Notebook",
                  isPasswordSection: false,
                  keyToEncrypt: "0",
                ),
              ),
            );
          },
          index: 1,
          icon: Icons.settings,
          photoPath: "assets/images/notebook.png",
          title: "Notebook",
          subtitle: "Store your all notes here",
          buttonText: "Open",
          isRightCurve: true,
        ),
        MainScreenBox(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyMPin(
                  auth: auth,
                  whereToNavigate: "PasswordSection",
                ),
              ),
            );
          },
          index: 2,
          icon: Icons.settings,
          photoPath: "assets/images/walt.png",
          title: "Password",
          subtitle: "Store Password Securely",
          buttonText: "Open",
          isRightCurve: false,
        ),
      ],
    );
  }
}
