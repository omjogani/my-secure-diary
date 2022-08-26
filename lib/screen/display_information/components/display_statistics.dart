import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/constant.dart';
import 'package:diary/provider/realtime_sync_provider.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayStatistics extends StatefulWidget {
  const DisplayStatistics({
    Key? key,
    required this.isPasswordSection,
    required this.auth,
  }) : super(key: key);
  final bool isPasswordSection;
  final AuthBase auth;

  @override
  State<DisplayStatistics> createState() => DisplayStatisticsState();
}

class DisplayStatisticsState extends State<DisplayStatistics> {
  int totalItems = -1;
  String lastUpdated = "";

  @override
  void initState() {
    super.initState();
    getTotalItems();
    getLastUpdated();
  }

  void getTotalItems() {
    FirebaseFirestore.instance
        .collection(widget.isPasswordSection ? 'password' : 'notebook')
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        totalItems = snapshot.data()![
            widget.isPasswordSection ? 'totalPasswords' : 'totalNotes'];
      });
    });
  }

  void getLastUpdated() {
    FirebaseFirestore.instance
        .collection(widget.isPasswordSection ? 'password' : 'notebook')
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        DateTime dateTime = snapshot.data()!['lastUpdated'].toDate();
        lastUpdated = "${(dateTime.hour % 12).toString().padLeft(2, '0')}:${dateTime.minute..toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder<bool>(
        valueListenable: RealTimeStatisticsSyncProvider.isNeedToSync,
        builder: (BuildContext context, bool value, Widget? child) {
          if (value) {
            getTotalItems();
            getLastUpdated();
          }
          return Container(
            width: size.width,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: kGradientColors[9],
              ),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Statistics",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InnerHalfContainer(
                          widgetList: <Widget>[
                            const AutoSizeText(
                              "Total",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            totalItems < 0
                                ? const CupertinoActivityIndicator(
                                    color: Colors.black)
                                : AutoSizeText(
                                    "$totalItems",
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: InnerHalfContainer(
                          widgetList: <Widget>[
                            const AutoSizeText(
                              "Last Updated",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            lastUpdated == ""
                                ? const CupertinoActivityIndicator(
                                    color: Colors.black)
                                : AutoSizeText(
                                    lastUpdated,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class InnerHalfContainer extends StatelessWidget {
  const InnerHalfContainer({
    Key? key,
    required this.widgetList,
  }) : super(key: key);
  final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      alignment: Alignment.topCenter,
      width: size.width,
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white54.withOpacity(0.2)
            : Colors.black54.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25.0,
            spreadRadius: 1,
            offset: Offset(0.0, 0.75),
          )
        ],
      ),
      child: Column(children: widgetList),
    );
  }
}
