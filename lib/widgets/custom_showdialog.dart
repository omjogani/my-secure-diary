import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomShowDialog {
  void showCustomDialog(
      BuildContext context, String content, String buttonText) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 23.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 23.0,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> onWillPopExit(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Text(
              "Do you really want to Exit the App?",
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 23.0,
                    color: Colors.blue,
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
        ) ??
        false;
  }
}
