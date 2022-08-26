import 'package:diary/constant.dart';
import 'package:flutter/material.dart';

class CustomFullWidthTextField extends StatelessWidget {
  const CustomFullWidthTextField({
    Key? key,
    required this.hintText,
    required this.onSaved,
    required this.controller,
    required this.onChanged,
    required this.keyboardType,
    required this.validator,
  }) : super(key: key);
  final String hintText;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F5FA),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75),
                ),
              ],
            ),
            child: TextFormField(
              onChanged: onChanged,
              onSaved: onSaved,
              validator: validator,
              controller: controller,
              cursorColor: Colors.black,
              keyboardType: keyboardType,
              cursorRadius: Radius.circular(10.0),
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                fillColor: Colors.black,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFullWidthButton extends StatelessWidget {
  const CustomFullWidthButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 17.0),
        width: size.width * 0.85,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: const Color(0xFFFF5F2D),
          color: buttonColor,
          borderRadius: BorderRadius.circular(20.0),
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
