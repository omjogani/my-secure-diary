import 'package:diary/constant.dart';
import 'package:diary/provider/realtime_theme_sync_provider.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/settings/components/colors_toggle.dart';
import 'package:diary/screen/settings/components/dark_light_mode_toggle.dart';
import 'package:diary/screen/user_details/user_details.dart';
import 'package:diary/screen/verify_mpin/verify_mpin.dart';
import 'package:diary/screen/wrapper.dart';
import 'package:diary/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
    required this.auth,
    required this.currentIndexTheme,
  }) : super(key: key);
  final AuthBase auth;
  final int currentIndexTheme;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SharedPreferences preferences;
  late List<Color> currentSelectedBackgroundShadowColor;

  void _signOutNotify(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const Text(
          "Are you sure want to Logout?",
          style: TextStyle(
            fontSize: 23.0,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              try {
                await widget.auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Wrapper(auth: Auth()),
                  ),
                );
              } catch (e) {
                print(e.toString());
              }
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "No",
              style: TextStyle(fontSize: 23.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _updateName(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetails(
          auth: widget.auth,
          navigationRoute: "Pop",
        ),
      ),
    );
  }

  void _updateMPin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyMPin(
          auth: widget.auth,
          whereToNavigate: "UpdateMPin",
        ),
      ),
    );
  }

  void _lockMyDiary(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const Text(
          "You won't be able to unlock Diary by your self, Are you sure want to lock Diary?",
          style: TextStyle(
            fontSize: 23.0,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyMPin(
                    auth: widget.auth,
                    whereToNavigate: "LockMyDiary",
                  ),
                ),
              );
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "No",
              style: TextStyle(fontSize: 23.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future changeThemeToSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
      getCurrentIndex = 0;
    }
    setState(() {
      if (getCurrentIndex! > 3) {
        getCurrentIndex = 0;
      } else {
        getCurrentIndex = getCurrentIndex! + 1;
      }
      preferences.setInt("themeIndex", getCurrentIndex!);
      currentSelectedBackgroundShadowColor =
          kBackgroundShadowColor[getCurrentIndex!];
    });
    RealTimeThemeSyncProvider.isNeedToSync.value = true;
  }

  @override
  void initState() {
    currentSelectedBackgroundShadowColor =
        kBackgroundShadowColor[widget.currentIndexTheme];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 25.0),
          // NavBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Settings",
                  style: buttonTextStyle.copyWith(fontSize: 27.0),
                  maxLines: 1,
                ),
                Row(
                  children: <Widget>[
                    ColorsToggle(
                      color: currentSelectedBackgroundShadowColor[0],
                      onPressed: () {
                        setState(() {
                          changeThemeToSharedPreferences();
                        });
                      },
                    ),
                    const SizedBox(width: 10.0),
                    DarkLightModeToggle(
                      color: currentSelectedBackgroundShadowColor[0],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          // Settings Tiles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: <Widget>[
                CustomSettingTile(
                  color: currentSelectedBackgroundShadowColor,
                  icon: Icon(
                    Icons.change_circle_outlined,
                    color: currentSelectedBackgroundShadowColor[0]
                        .withOpacity(1.0),
                  ),
                  onPressed: () => _updateName(context),
                  text: "Change Name",
                ),
                const SizedBox(height: 10.0),
                CustomSettingTile(
                  color: currentSelectedBackgroundShadowColor,
                  icon: Icon(
                    Icons.pin,
                    color: currentSelectedBackgroundShadowColor[0]
                        .withOpacity(1.0),
                  ),
                  onPressed: () => _updateMPin(context),
                  text: "Change MPIN",
                ),
                const SizedBox(height: 10.0),
                CustomSettingTile(
                  color: currentSelectedBackgroundShadowColor,
                  icon: Icon(
                    Icons.lock,
                    color: currentSelectedBackgroundShadowColor[0]
                        .withOpacity(1.0),
                  ),
                  onPressed: () => _lockMyDiary(context),
                  text: "Lock My Diary",
                ),
                // const SizedBox(height: 10.0),
                // CustomSettingTile(
                //   color: currentSelectedBackgroundShadowColor,
                //   icon: Icon(
                //     Icons.info,
                //     color: currentSelectedBackgroundShadowColor[0]
                //         .withOpacity(1.0),
                //   ),
                //   onPressed: () {
                //   },
                //   text: "Info",
                // ),
                const SizedBox(height: 10.0),
                CustomSettingTile(
                  color: currentSelectedBackgroundShadowColor,
                  icon: Icon(
                    Icons.logout_rounded,
                    color: currentSelectedBackgroundShadowColor[0]
                        .withOpacity(1.0),
                  ),
                  onPressed: () => _signOutNotify(context),
                  text: "Logout",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final List<Color> color;
  final Icon icon;
  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white54.withOpacity(0.2)
              : Colors.black54.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 42.0,
                  height: 42.0,
                  child: icon,
                ),
                const SizedBox(width: 15.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
