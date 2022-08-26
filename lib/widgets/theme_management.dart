import 'package:shared_preferences/shared_preferences.dart';

class ThemeManagement {
  late SharedPreferences preferences;

  Future<int> getCurrentThemeIndex()async{
    await sharedPreferencesInitialization();
    int? currentIndex = preferences.getInt("themeIndex");
    return currentIndex ?? 0;
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
    }
  }
}