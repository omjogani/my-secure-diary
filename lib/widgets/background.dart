import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MPinBackground extends StatefulWidget {
  const MPinBackground({Key? key}) : super(key: key);

  @override
  State<MPinBackground> createState() => _MPinBackgroundState();
}

class _MPinBackgroundState extends State<MPinBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: -150,
          top: -100,
          child: Opacity(
            opacity: 0.6,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.blue.withAlpha(175),
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -150,
          top: MediaQuery.of(context).size.height / 1.5,
          child: Opacity(
            opacity: 0.3,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.yellow.withAlpha(175),
                    // isDarkTheme ? const Color(0xFF21172F) : Colors.white,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -180,
          top: MediaQuery.of(context).size.height / 4,
          child: Opacity(
            opacity: 0.6,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.green.withAlpha(175),
                    // isDarkTheme ? const Color(0xFF21172F) : Colors.white,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
