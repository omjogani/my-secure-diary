import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorsToggle extends StatefulWidget {
  const ColorsToggle({
    Key? key,
    required this.color,
    required this.onPressed,
  }) : super(key: key);
  final Color color;
  final Function onPressed;

  @override
  State<ColorsToggle> createState() => _ColorsToggleState();
}

class _ColorsToggleState extends State<ColorsToggle> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDarkMode;
    return GestureDetector(
      onTap: () => widget.onPressed(),
      child: Tooltip(
        message: "Toggle Colors",
        child: Container(
          height: 42.0,
          width: 42.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDarkTheme
                ? Colors.white54.withOpacity(0.2)
                : Colors.black54.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 12.0,
              ),
            ],
          ),
          child: const Icon(Icons.change_circle),
        ),
      ),
    );
  }
}
