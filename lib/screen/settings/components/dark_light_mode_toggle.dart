import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkLightModeToggle extends StatefulWidget {
  const DarkLightModeToggle({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  State<DarkLightModeToggle> createState() => _DarkLightModeToggleState();
}

class _DarkLightModeToggleState extends State<DarkLightModeToggle> {
  late SharedPreferences preferences;
  bool? isDarkModeLocal;

  @override
  void initState() {
    getCurrentThemeFromSharedPreferences();
    super.initState();
  }

  void getCurrentThemeFromSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    bool? getCurrentMode = preferences.getBool("isDarkMode");
    if (getCurrentMode == null) {
      preferences.setBool("isDarkMode", false);
      getCurrentMode = false;
    }
    setState(() {
      isDarkModeLocal = getCurrentMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDarkModeLocal == null) {
      return const CupertinoActivityIndicator();
    }
    return GestureDetector(
      onTap: isDarkModeLocal == null
          ? () {}
          : () async {
            print("Pressed");
              preferences = await SharedPreferences.getInstance();
              isDarkModeLocal = preferences.getBool("isDarkMode");
              if (isDarkModeLocal == null) {
                preferences.setBool("isDarkMode", false);
                isDarkModeLocal = false;
              }
              preferences.setBool("isDarkMode", !isDarkModeLocal!);
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              isDarkModeLocal = !isDarkModeLocal!;
              provider.toggleTheme(isDarkModeLocal!);
            },
      child: Container(
        height: 42.0,
        width: 42.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDarkModeLocal!
              ? Colors.white54.withOpacity(0.2)
              : Colors.black54.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 12.0,
            ),
          ],
        ),
        child: Icon(
          isDarkModeLocal! ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        ),
      ),
    );
  }
}
