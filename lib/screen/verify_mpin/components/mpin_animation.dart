import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MPinAnimationController {
  late void Function(String) animate;
  late void Function() clear;
}

class MPinAnimation extends StatefulWidget {
  final MPinAnimationController controller;
  const MPinAnimation({Key? key, required this.controller}) : super(key: key);

  @override
  _MPinAnimationState createState() => _MPinAnimationState(controller);
}

class _MPinAnimationState extends State<MPinAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  String pin = '';

  void animate(String input) {
    _controller.forward();
    setState(() {
      pin = input;
    });
  }

  void clear() {
    setState(() {
      pin = '';
    });
  }

  _MPinAnimationState(controller) {
    controller.animate = animate;
    controller.clear = clear;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      }
      setState(() {});
    });
    _sizeAnimation = Tween<double>(begin: 24, end: 72).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    return Container(
      height: 64.0,
      width: 64.0,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        height: _sizeAnimation.value,
        width: _sizeAnimation.value,
        decoration: BoxDecoration(
          color: pin == '' ? isDarkTheme ? Colors.white38 : Colors.black45 : isDarkTheme ? Colors.white : Colors.black87.withOpacity(0.7),
          borderRadius: BorderRadius.circular(_sizeAnimation.value / 2),
        ),
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _sizeAnimation.value / 48,
            child: Text(
              pin,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.black :Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
