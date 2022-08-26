import 'package:diary/constant.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainScreenBox extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isRightCurve;
  final String photoPath;
  final Function onPressed;
  const MainScreenBox({
    Key? key,
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.isRightCurve,
    required this.photoPath,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MainScreenBox> createState() => _MainScreenBoxState();
}

class _MainScreenBoxState extends State<MainScreenBox> {
  final List<List<Color>> colors = [
    [
      const Color(0xFFfb7981),
      const Color(0xFFffb099),
    ],
    [
      const Color(0xFF5e5dde),
      const Color(0xFF7990e7),
    ],
    [
      const Color(0xFFf35689),
      const Color(0xFFfd98ba),
    ],
    [
      const Color(0xFF221669),
      const Color(0xFF7272cb),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: widget.isRightCurve
                    ? const Radius.circular(10.0)
                    : const Radius.circular(85.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                topRight: widget.isRightCurve
                    ? const Radius.circular(85.0)
                    : const Radius.circular(10.0),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: colors[widget.index],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 16.0,
                  offset: const Offset(0, 5),
                  color: colors[widget.index][0].withOpacity(0.2),
                ),
                BoxShadow(
                  blurRadius: 16.0,
                  offset: const Offset(10, 3),
                  color: colors[widget.index][0].withOpacity(0.2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: widget.isRightCurve
                    ? const Radius.circular(10.0)
                    : const Radius.circular(85.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                topRight: widget.isRightCurve
                    ? const Radius.circular(85.0)
                    : const Radius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  glassCircle(),
                  imageInGlass(),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      children: <Widget>[
                        titleSubtitle(),
                        openButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget glassCircle() {
    return Positioned(
      left: widget.isRightCurve ? -20 : null,
      top: -50,
      right: widget.isRightCurve ? null : -20,
      child: Container(
        height: 120.0,
        width: 120.0,
        decoration: BoxDecoration(
          color: Colors.white60.withOpacity(0.3),
          // color: Colors.black,
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
    );
  }

  Widget imageInGlass() {
    return Positioned(
      left: widget.isRightCurve ? 15 : null,
      right: widget.isRightCurve ? null : 15,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 8.0,
              offset: const Offset(0, 10),
              color: colors[widget.index][0].withOpacity(0.3),
            ),
          ],
        ),
        child: Image.asset(
          widget.photoPath,
          height: 65.0,
        ),
      ),
    );
  }

  Widget titleSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      alignment: Alignment.topLeft,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: titleTextStyleWhite,
          ),
          const SizedBox(height: 10.0),
          AutoSizeText(
            widget.subtitle,
            maxLines: 2,
            maxFontSize: 18.0,
            style: subtitleTextStyleWhite,
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget openButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white60.withOpacity(0.3),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 16.0,
                offset: const Offset(0, 8),
                color: colors[widget.index][0].withOpacity(0.3),
              ),
              BoxShadow(
                blurRadius: 16.0,
                offset: const Offset(15, 5),
                color: colors[widget.index][0].withOpacity(0.3),
              ),
            ],
          ),
          child: AutoSizeText(
            widget.buttonText,
            maxLines: 1,
            style: buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
