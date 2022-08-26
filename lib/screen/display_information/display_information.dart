import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/constant.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/provider/realtime_sync_provider.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/crud_information/add_information.dart';
import 'package:diary/screen/crud_information/update_information.dart';
import 'package:diary/screen/display_information/components/display_list_tile.dart';
import 'package:diary/screen/display_information/components/display_statistics.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/notebook_datebase_service.dart';
import 'package:diary/services/passwords_database_service.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayInformation extends StatefulWidget {
  const DisplayInformation({
    Key? key,
    required this.auth,
    required this.title,
    required this.isPasswordSection,
    required this.keyToEncrypt,
  }) : super(key: key);
  final AuthBase auth;
  final String title;
  final bool isPasswordSection;
  final String keyToEncrypt;

  @override
  State<DisplayInformation> createState() => _DisplayInformationState();
}

class _DisplayInformationState extends State<DisplayInformation> {
  late SharedPreferences preferences;
  int currentIndexTheme = -1;
  void _deleteItem(List<dynamic> reversedItems, int index) {
    try {
      if (widget.isPasswordSection) {
        PasswordDatabaseService(uid: widget.auth.currentUser!.uid)
            .deletePassword(
          "${reversedItems[index]['title']}",
          "${reversedItems[index]['password']}",
          reversedItems.length - index - 1,
        );
      } else {
        NoteBookDatabaseService(uid: widget.auth.currentUser!.uid).deleteNotes(
          "${reversedItems[index]['title']}",
          "${reversedItems[index]['description']}",
          reversedItems.length - index - 1,
        );
      }
    } catch (e) {
      print("DELETE EXCEPTION: ${e.toString()}");
    }

    Navigator.of(context).pop(true);
  }

  Future<bool> onWillPop() async {
    if (widget.isPasswordSection) {
      Navigator.pop(context, false);
      Navigator.pop(context, false);
      return true;
    } else {
      Navigator.pop(context, false);
      return true;
    }
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
    }
    setState(() {
      currentIndexTheme = getCurrentIndex!;
    });
  }

  @override
  void initState() {
    sharedPreferencesInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Provider.of<ThemeProvider>(context).isDarkMode;
    final currentConnectionStatus =
        Provider.of<InternetConnectivityStatus?>(context);
    if (currentConnectionStatus == null) {
      return const FullScreenLoading(
        message: "Checking Internet Connection...",
        simpleLoadingAnimation: false,
      );
    }
    if (currentConnectionStatus == InternetConnectivityStatus.offline) {
      return const NoInternetScreen();
    }
    if (currentIndexTheme == -1) {
      return const FullScreenLoading(
          message: "Loading...", simpleLoadingAnimation: true);
    }
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => onWillPop(),
        child: Stack(
          children: <Widget>[
            Background(listOfColors: kBackgroundShadowColor[currentIndexTheme]),
            Column(
              children: <Widget>[
                const SizedBox(height: 25.0),
                // NavBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.isPasswordSection) {
                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                        },
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
                                color: kBackgroundShadowColor[currentIndexTheme]
                                        [0]
                                    .withOpacity(0.3),
                                offset: const Offset(0, 8),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                      Text(
                        widget.title,
                        style: buttonTextStyle.copyWith(fontSize: 27.0),
                        maxLines: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                          RealTimeStatisticsSyncProvider.isNeedToSync.value =
                              true;
                        },
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
                                color: kBackgroundShadowColor[currentIndexTheme]
                                        [0]
                                    .withOpacity(0.3),
                                offset: const Offset(0, 8),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.refresh_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Statistics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DisplayStatistics(
                    isPasswordSection: widget.isPasswordSection,
                    auth: widget.auth,
                  ),
                ),
                const SizedBox(height: 10.0),
                // List
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(
                          widget.isPasswordSection ? 'password' : 'notebook')
                      .doc(widget.auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitFadingCircle(
                              color: kBackgroundShadowColor.first[0],
                            ),
                            const Text(
                              "Fetching Data...",
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    final DocumentSnapshot document =
                        snapshot.data as DocumentSnapshot;

                    final Map<String, dynamic> documentData =
                        document.data() as Map<String, dynamic>;

                    List checkingForEmptyList = documentData[
                        widget.isPasswordSection ? 'passwords' : 'notes'];
                    if (documentData[widget.isPasswordSection
                                ? 'passwords'
                                : 'notes'] ==
                            null ||
                        checkingForEmptyList.isEmpty) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset(
                              "assets/lottie/no_items_found.json",
                              height: 200.0,
                              width: 200.0,
                            ),
                            Text(
                              widget.isPasswordSection
                                  ? "Empty Password Section..."
                                  : "Empty Notebook...",
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    final List<Map<String, dynamic>> itemDetailList =
                        (documentData[
                                widget.isPasswordSection
                                    ? 'passwords'
                                    : 'notes'] as List)
                            .map((itemDetail) =>
                                itemDetail as Map<String, dynamic>)
                            .toList();
                    var itemDetailsListReversed =
                        itemDetailList.reversed.toList();

                    _buildListTileHere(int index) {
                      final Map<String, dynamic> itemDetail =
                          itemDetailsListReversed[index];
                      final String title = itemDetail['title'];
                      final DateTime dateTime = itemDetail['dateTime'].toDate();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Dismissible(
                            key: Key(
                                (itemDetailsListReversed.length - index - 1)
                                    .toString()),
                            confirmDismiss: (direction) async {
                              return await DismissConfirmation(
                                  context, itemDetailsListReversed, index);
                            },
                            background: TileBackground(true),
                            secondaryBackground: TileBackground(false),
                            child: CustomListTile(
                              title: title,
                              // title: "${reversedNotes[index]['title']}",
                              // dateTime: reversedNotes[index]['dateTime'].toDate(),
                              dateTime: dateTime,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateDeleteInformation(
                                      auth: widget.auth,
                                      isPasswordSection:
                                          widget.isPasswordSection,
                                      index: itemDetailsListReversed.length -
                                          index -
                                          1,
                                      title: widget.isPasswordSection
                                          ? 'Update Password'
                                          : "Update Note",
                                      keyToEncrypt: widget.keyToEncrypt,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: itemDetailsListReversed.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildListTileHere(index);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInformation(
                isPasswordSection: widget.isPasswordSection,
                keyToEncrypt: widget.keyToEncrypt,
                auth: widget.auth,
                title: widget.isPasswordSection ? "Passwords" : "Notes",
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            height: 55.0,
            width: 55.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: kGradientColors[9],
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1.0,
                  blurRadius: 25.0,
                  offset: Offset(0.0, 0.75),
                ),
              ],
            ),
            child: const Icon(
              Icons.note_add,
              size: 25.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> DismissConfirmation(
      BuildContext context, List<dynamic> reversedNotes, int index) async {
    return await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const Text(
          "Are you sure want to delete?",
          style: TextStyle(
            fontSize: 23.0,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => _deleteItem(reversedNotes, index),
            child: const Text(
              "Yes",
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              "No",
              style: TextStyle(fontSize: 23.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget TileBackground(bool isLeft) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            isLeft
                ? const Icon(
                    Icons.delete,
                  )
                : Container(),
            SizedBox(width: isLeft ? 5.0 : 0.0),
            Text(
              "Delete\nPermanently",
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: isLeft ? 0.0 : 5.0),
            !isLeft
                ? const Icon(
                    Icons.delete,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}