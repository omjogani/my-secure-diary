import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumericPad extends StatelessWidget {

  final Function(int) onNumberSelected;

  const NumericPad({Key? key, required this.onNumberSelected}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(1, isDarkMode),
                buildNumber(2, isDarkMode),
                buildNumber(3, isDarkMode),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(4, isDarkMode),
                buildNumber(5, isDarkMode),
                buildNumber(6, isDarkMode),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(7, isDarkMode),
                buildNumber(8, isDarkMode),
                buildNumber(9, isDarkMode),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildEmptySpace(),
                buildNumber(0, isDarkMode),
                buildBackspace(isDarkMode),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget buildNumber(int number, bool isDarkMode) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white38 : Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspace(bool isDarkMode) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(-1);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white38 : Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.backspace,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return Expanded(
      child: Container(),
    );
  }

}