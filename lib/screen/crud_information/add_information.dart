import 'package:diary/constant.dart';
import 'package:diary/encryption/encryption.dart';
import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/provider/realtime_sync_provider.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/crud_information/components/custom_full_width_button.dart';
import 'package:diary/screen/crud_information/components/description_input_field.dart';
import 'package:diary/screen/crud_information/components/title_input_field.dart';
import 'package:diary/screen/no_internet/no_internet_screen.dart';
import 'package:diary/screen/user_details/components/background.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/notebook_datebase_service.dart';
import 'package:diary/services/passwords_database_service.dart';
import 'package:diary/widgets/custom_snackbar.dart';
import 'package:diary/widgets/fullscreen_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInformation extends StatefulWidget {
  const AddInformation({
    Key? key,
    required this.isPasswordSection,
    required this.auth,
    required this.title,
    required this.keyToEncrypt,
  }) : super(key: key);
  final bool isPasswordSection;
  final AuthBase auth;
  final String title;
  final String keyToEncrypt;

  @override
  State<AddInformation> createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late SharedPreferences preferences;
  int currentIndexTheme = -1;
  late String title, description, password;
  bool _isValidTitle = false;

  String? _validateTitle(String copyOfTitle) {
    if (copyOfTitle.isEmpty) {
      return "Please Enter Title...";
    } else if (copyOfTitle.length > 255) {
      return "Length of Title exceeded";
    }
    return null;
  }

  String? _validatepassword(String copyOfPassword) {
    if (copyOfPassword.isEmpty) {
      return "Please Enter Password...";
    }
    return null;
  }

  String? _validateDescription(String copyOfDescription) {
    if (copyOfDescription.isEmpty) {
      return "Please Enter Description...";
    }
    return null;
  }

  void _onTitleEditingComplete() {
    if (widget.isPasswordSection) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    } else {
      FocusScope.of(context).requestFocus(_descriptionFocusNode);
    }
  }

  void _insertInformationToDB() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      title = _titleController.text.trim();
      if (widget.isPasswordSection) {
        password = _passwordController.text.trim();
      } else {
        description = _descriptionController.text.trim();
      }
      try {
        if (widget.isPasswordSection) {
          Encryption enc = Encryption(messageToBeEncrypted: password);
          final String encryptedPassword = enc.encryptMe(int.parse(widget.keyToEncrypt[3]));
          await PasswordDatabaseService(uid: widget.auth.currentUser!.uid)
              .insertPassword(title, encryptedPassword, DateTime.now());
        } else {
          await NoteBookDatabaseService(uid: widget.auth.currentUser!.uid)
              .insertNotes(title, description, DateTime.now());
        }
      } catch (e) {
        print("My Exception Occurs: ${e.toString()}");
      }
      customSnackBar(
        context,
        widget.isPasswordSection
            ? "Password added Successfully"
            : "Notes added Successfully",
        Colors.green.shade200,
        const Icon(
          Icons.check_circle_rounded,
          size: 30.0,
          color: Colors.green,
        ),
        false,
      );
      RealTimeStatisticsSyncProvider.isNeedToSync.value = true;
      Navigator.pop(context);
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
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            Background(listOfColors: kBackgroundShadowColor[currentIndexTheme]),
            Column(
              children: <Widget>[
                const SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
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
                                color: kBackgroundShadowColor[currentIndexTheme].first
                                    .withOpacity(0.3),
                                offset: const Offset(0, 8),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Add ${widget.title}",
                              style: buttonTextStyle.copyWith(fontSize: 27.0),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Form(
                        key: _key,
                        autovalidateMode: _isValidTitle
                            ? AutovalidateMode.always
                            : AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: <Widget>[
                            CustomTitleTextField(
                              hintText: widget.isPasswordSection
                                  ? "Application Name"
                                  : "Title",
                              onSaved: (str) {
                                title = str!;
                              },
                              controller: _titleController,
                              onChanged: (val) {},
                              titleFocusNode: _titleFocusNode,
                              onEditingComplete: _onTitleEditingComplete,
                              keyboardType: TextInputType.text,
                              validator: (str) => _validateTitle(str!),
                            ),
                            CustomTextAreaField(
                              onSaved: (str) {
                                if (widget.isPasswordSection) {
                                  password = str!;
                                } else {
                                  description = str!;
                                }
                              },
                              hintText: widget.isPasswordSection
                                  ? "Enter Passwords here..."
                                  : "Start Typing here...",
                              controller: widget.isPasswordSection
                                  ? _passwordController
                                  : _descriptionController,
                              onChanged: (val) {},
                              descriptionFocusNode: widget.isPasswordSection
                                  ? _passwordFocusNode
                                  : _descriptionFocusNode,
                              keyboardType: TextInputType.text,
                              validator: (str) => widget.isPasswordSection
                                  ? _validatepassword(str!)
                                  : _validateDescription(str!),
                            ),
                            const SizedBox(height: 20.0),
                            CustomFullWidthAddInfoButton(
                              buttonText: widget.isPasswordSection
                                  ? "Add Password"
                                  : "Add Notes",
                                  buttonColor: kBackgroundShadowColor[currentIndexTheme].last,
                              onTap: () => _insertInformationToDB(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
