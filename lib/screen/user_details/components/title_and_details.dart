import 'package:diary/constant.dart';
import 'package:flutter/material.dart';

class TitleAndDetails extends StatelessWidget {
  const TitleAndDetails({Key? key, required this.titleString})
      : super(key: key);
  final String titleString;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Text(
            "Welcome To\nSecure Diary",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 28.0,
          ),
          Text(
            titleString,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }
}
