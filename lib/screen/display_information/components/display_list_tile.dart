import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.dateTime,
  }) : super(key: key);
  final String title;
  final Function onPressed;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    final Size size = MediaQuery.of(context).size;
    final List<String> months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL","AUG","SEP","OCT","NOV","DEC",];
    final int currentMonth = dateTime.month;
    final String monthInAlphabets = months[currentMonth -1 ];
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: size.width * 0.95,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white54.withOpacity(0.2)
              : Colors.black54.withOpacity(0.4),
          // borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 1.0,
                    blurRadius: 25.0,
                    offset: Offset(0.0, 0.75),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: AutoSizeText(
                "${dateTime.day}\n$monthInAlphabets",
                maxLines: 2,
                
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
