import 'package:diary/enums/internet_connectivity_status.dart';
import 'package:diary/provider/theme_provider.dart';
import 'package:diary/screen/splash_screen/splash_screen.dart';
import 'package:diary/services/auth.dart';
import 'package:diary/services/internet_monitor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _snapshot) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return StreamProvider<InternetConnectivityStatus?>(
          initialData: null,
          create: (context) => InternetMonitorService()
              .internetConnectionStatusController
              .stream,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Diary',
            themeMode: themeProvider.themeMode,
            darkTheme: MyThemes.darkTheme,
            theme: ThemeData(
              fontFamily: "SF Pro Text",
            ),
            home: Splash(
              auth: Auth(),
            ),
          ),
        );
      },
    );
  }
}
