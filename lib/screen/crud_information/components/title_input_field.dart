import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTitleTextField extends StatelessWidget {
  const CustomTitleTextField({
    Key? key,
    required this.hintText,
    required this.onSaved,
    required this.controller,
    required this.onChanged,
    required this.keyboardType,
    required this.validator,
    required this.titleFocusNode,
    required this.onEditingComplete,
  }) : super(key: key);
  final String hintText;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FocusNode titleFocusNode;
  final Function onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            width: size.width * 0.90,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white54.withOpacity(0.2)
                  : Colors.black54.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              onChanged: onChanged,
              focusNode: titleFocusNode,
              onEditingComplete: () => onEditingComplete(),
              onSaved: onSaved,
              textInputAction: TextInputAction.next,
              validator: validator,
              controller: controller,
              keyboardType: keyboardType,
              cursorRadius: const Radius.circular(10.0),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                errorStyle: TextStyle(
                  color: isDarkMode ?Colors.white54:Colors.black45,
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