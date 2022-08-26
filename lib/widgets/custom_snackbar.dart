import 'package:flutter/material.dart';

void customSnackBar(BuildContext snackBarContext, String snackBarMessage,
    Color backgroundColor, Icon icon, bool isWidgetTreeExist) {
  final customSnackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(width: 1.8, color: Colors.black),
        color: backgroundColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25.0,
            spreadRadius: 1,
            offset: Offset(0.0, 0.75),
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (isWidgetTreeExist) {
            ScaffoldMessenger.of(snackBarContext).hideCurrentSnackBar();
          }
        },
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(13.0),
              ),
              width: 42.0,
              height: 42.0,
              child: icon,
            ),
            const SizedBox(width: 15.0),
            Text(
              snackBarMessage,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(snackBarContext).showSnackBar(customSnackBar);
}
