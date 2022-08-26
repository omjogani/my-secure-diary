import 'package:diary/model/mpin_model.dart';
import 'package:diary/screen/verify_mpin/components/mpin_animation.dart';
import 'package:flutter/material.dart';

class MPinController {
  late void Function(String) addInput;
  late void Function() delete;
  late void Function() notifyWrongInput;
  late void Function() clearInput;
}

class MPinWidget extends StatefulWidget {
  final int pinLength;
  final MPinController controller;
  final Function(String) onCompleted;
  const MPinWidget({
    Key? key,
    required this.pinLength,
    required this.controller,
    required this.onCompleted,
  })  : assert(pinLength <= 6 && pinLength > 0),
        super(key: key);

  @override
  _MPinWidgetState createState() => _MPinWidgetState(controller);
}

class _MPinWidgetState extends State<MPinWidget>
    with SingleTickerProviderStateMixin {
  late List<MPinAnimationController> _animationControllers;
  late AnimationController _wrongInputAnimationController;
  late Animation<double> _wiggleAnimation;
  String mPin = '';

  _MPinWidgetState(MPinController controller) {
    controller.addInput = addInput;
    controller.delete = delete;
    controller.notifyWrongInput = notifyWrongInput;
    controller.clearInput = clearInput;
  }

  void addInput(String input) async {
    mPin += input;
    if (mPin.length < widget.pinLength) {
      _animationControllers[mPin.length - 1].animate(input);
    } else if (mPin.length == widget.pinLength) {
      _animationControllers[mPin.length - 1].animate(input);
      await Future.delayed(const Duration(milliseconds: 300));
      widget.onCompleted.call(mPin);
      mPin = '';
    }
  }

  void delete() {
    if (mPin.isNotEmpty) {
      mPin = mPin.substring(0, mPin.length - 1);
      _animationControllers[mPin.length].animate('');
    }
  }

  void notifyWrongInput() {
    _wrongInputAnimationController.forward();
    _animationControllers.forEach((controller) {
      controller.clear();
    });
  }

  void clearInput() {
    _animationControllers.forEach((controller) {
      controller.clear();
    });
    mPin = '';
  }

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(widget.pinLength, (index) {
      return MPinAnimationController();
    });

    _wrongInputAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _wrongInputAnimationController.reverse();
        }
      });

    _wiggleAnimation = Tween<double>(begin: 0.0, end: 24.0).animate(
        CurvedAnimation(
            parent: _wrongInputAnimationController, curve: Curves.elasticIn));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_wiggleAnimation.value, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.pinLength,
          (index) {
            return MPinAnimation(
              controller: _animationControllers[index],
            );
          },
        ),
      ),
    );
  }
}
