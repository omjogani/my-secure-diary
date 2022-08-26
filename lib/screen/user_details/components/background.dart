import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key, required this.listOfColors}) : super(key: key);
  final List<Color> listOfColors;

  @override
  Widget build(BuildContext context) {
    
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          top: -(size.width / 1.5),
          left: -(size.width / 1.5),
          child: Container(
            height: size.height / 1.5,
            width: size.height / 1.5,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: listOfColors,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -(size.width / 1.5),
          right: -(size.width / 1.5),
          child: Container(
            height: size.height / 1.5,
            width: size.height / 1.5,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: listOfColors,
              ),
            ),
          ),
        ),
      ],
    );
  }
}