import 'package:flutter/material.dart';
import 'package:diary/constant.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:diary/model/info_data.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 25.0),
          Text(
            "Information",
            style: buttonTextStyle.copyWith(fontSize: 27.0),
            maxLines: 1,
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ExpansionPanelList.radio(
                        dividerColor: Colors.white,
                        elevation: 1.0,
                        expandedHeaderPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
                        animationDuration: const Duration(seconds: 1),
                        children: allItems
                            .map(
                              (item) => ExpansionPanelRadio(
                                // backgroundColor: isDarkMode
                                //     ? Colors.white54.withOpacity(0.2)
                                //     : Colors.black54.withOpacity(0.2),
                                backgroundColor:
                                    Colors.white54.withOpacity(0.2),
                                canTapOnHeader: true,
                                value: item.header,
                                headerBuilder: (context, isExpanded) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      item.header,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Text(
                                    item.body,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final List<Color> color;
  final Icon icon;
  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white54.withOpacity(0.2)
              : Colors.black54.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 42.0,
                  height: 42.0,
                  child: icon,
                ),
                const SizedBox(width: 15.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
