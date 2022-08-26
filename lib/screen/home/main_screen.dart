import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:diary/constant.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/provider/realtime_theme_sync_provider.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/home/home_screen.dart';
import 'package:diary/screen/info_screen/info_screen.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/settings/setting_screen.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/widgets/custom_showdialog.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:diary/widgets/theme_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  late PageController _pageController;
  late SharedPreferences preferences;
  late int currentTheme = -1;

  @override
  void initState() {
    sharedPreferencesInitialization();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
    }
    setState(() {
      currentTheme = getCurrentIndex!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
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
    if (currentTheme == -1) {
      return const FullScreenLoading(
          message: "Loading...", simpleLoadingAnimation: true);
    }
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: Stack(
          children: <Widget>[
            ValueListenableBuilder<bool>(
              valueListenable: RealTimeThemeSyncProvider.isNeedToSync,
              builder: (BuildContext context, bool value, Widget? child) {
                if (value) {
                  sharedPreferencesInitialization();
                }
                return Background(
                    listOfColors: kBackgroundShadowColor[currentTheme]);
              },
            ),
            SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => this.index = index);
                },
                children: <Widget>[
                  HomeScreen(
                    auth: widget.auth,
                    currentThemeIndex: currentTheme,
                  ),
                  SettingScreen(
                    auth: widget.auth,
                    currentIndexTheme: currentTheme,
                  ),
                  const InfoScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(isDarkTheme),
    );
  }

  Widget buildBottomNavigation(bool isDarkTheme) {
    final Color activeColor = isDarkTheme ? Colors.white : Colors.black;
    const Color inactiveColor = CupertinoColors.systemGrey;
    return BottomNavyBar(
      backgroundColor:
          isDarkTheme ? const Color(0xFF262626) : const Color(0xFFF2F2F2),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onItemSelected: (index) {
        setState(() {
          this.index = index;
        });
        _pageController.jumpToPage(index);
      },
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: const Text("Home"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.settings),
          title: const Text("Settings"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.info_circle),
          title: const Text("Info"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ],
    );
  }
}
