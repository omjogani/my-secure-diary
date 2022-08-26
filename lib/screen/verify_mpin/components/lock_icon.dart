import 'package:flutter/material.dart';

class LockUnlockIcon extends StatefulWidget {
  final bool isUnlocked;
  const LockUnlockIcon({Key? key, required this.isUnlocked}) : super(key: key);

  @override
  _LockUnlockIconState createState() => _LockUnlockIconState();
}

class _LockUnlockIconState extends State<LockUnlockIcon>
    with TickerProviderStateMixin {
  // late AnimationController _animationController;
  bool isUnlocked = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 450),
  //   );
  // }

  // void _handleOnPressed() {
  //   setState(() {
  //     isUnlocked = !isUnlocked;
  //     isUnlocked
  //         ? _animationController.forward()
  //         : _animationController.reverse();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
      child: Icon(
        widget.isUnlocked ? Icons.lock_open : Icons.lock,
        size: 70.0,
        color: Colors.white38,
      ),
    );
  }
}
