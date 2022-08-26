import 'package:diary/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({
    Key? key,
    required this.message,
    required this.simpleLoadingAnimation,
  }) : super(key: key);
  final String message;
  final bool simpleLoadingAnimation;


  @override
  Widget build(BuildContext context) {

    List<Color> currentSelectedBackgroundShadowColor =
        kBackgroundShadowColor[0];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                simpleLoadingAnimation
                    ? SpinKitFadingCircle(
                        color: currentSelectedBackgroundShadowColor[0]
                            .withOpacity(1.0))
                    : SpinKitWave(
                        color: currentSelectedBackgroundShadowColor[0]
                            .withOpacity(1.0)),
                const SizedBox(height: 15.0),
                Text(
                  message,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
