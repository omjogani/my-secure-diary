import 'package:diary/constant.dart';
import 'package:flutter/material.dart';

class CustomFullWidthAddInfoButton extends StatelessWidget {
  const CustomFullWidthAddInfoButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor,
  }) : super(key: key);

  final Function onTap;
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 17.0),
        width: size.width * 0.90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: const Color(0xFFFF5F2D),
          color: buttonColor.withOpacity(1.0),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 25.0,
              spreadRadius: 1,
              offset: Offset(0.0, 0.75),
            ),
          ],
        ),
        child: Text(
          buttonText,
          style: buttonTextStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
