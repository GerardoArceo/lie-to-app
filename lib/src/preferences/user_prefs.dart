import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {

  static final UserPrefs _instance = new UserPrefs._internal();

  factory UserPrefs() {
    return _instance;
  }

  UserPrefs._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get darkTheme {
    return _prefs.getBool('darkTheme') ?? true;
  }

  set darkTheme(bool value) {
    _prefs.setBool('darkTheme', value);
  }

  get uid {
    return _prefs.getString('uid') ?? null;
  }

  set uid(String value) {
    _prefs.setString('uid', value);
  }

  get showInitialInfo {
    return _prefs.getBool('showInitialInfo') ?? true;
  }

  set showInitialInfo(bool value) {
    _prefs.setBool('showInitialInfo', value);
  }
}