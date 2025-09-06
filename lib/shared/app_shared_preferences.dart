import 'dart:convert';

import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AppSharedPreferences {
  static var customSharedPreferences = AppSharedPreferences();
  SharedPreferences? _prefs;
 final String _ISLOGGEDINKEY = "isUserLoggeIn";
 String _AUTHTOKENKEY = "AccessToken";
 String _USERLOGINDATAKEY = 'userLoginData';
    String _IS_ONBOARDING_SEEN_KEY = "isOnBoardingSeen";

  Future<void> initPrefs() async {
    return await SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  Future<void> saveValue<T>(String key, T value)  async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }

    if (value is String) {
     await  _prefs!.setString(key, value);
    } else if (value is int) {
      _prefs!.setInt(key, value);
    } else if (value is double) {
      _prefs!.setDouble(key, value);
    } else if (value is bool) {
      _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      _prefs!.setStringList(key, value);
    } else if (value is Map<String, dynamic>) {
      final jsonString = jsonEncode(value);
      _prefs?.setString(key, jsonString);
    } else {
      throw Exception('Unsupported value type');
    }
  }

  getValue<T>(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    if (T == String) {
      return _prefs!.getString(key) as T?;
    } else if (T == int) {
      return _prefs!.getInt(key) as T?;
    } else if (T == double) {
      return _prefs!.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs?.getBool(key) as T?;
    } else if (T == List<String>) {
      return _prefs?.getStringList(key) as T?;
    } else if (T == Map<String, dynamic>) {
      final jsonString = _prefs!.getString(key);
      if (jsonString != null) {
        final data = jsonDecode(jsonString);
        if (data is Map<String, dynamic>) {
          return data as T?;
        } else {
          throw Exception('Invalid data type in shared preferences');
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Unsupported value type');
    }
  }

  void removeValue(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    _prefs!.remove(key);
  }

  Future<void> clearSharedPreference() async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    await _prefs!.clear();
  }
  Future<void> setAuthToken(String token)async {
await saveValue(_AUTHTOKENKEY, token);
  }
  String getAuthToken() {
    final token = AppSharedPreferences.customSharedPreferences.getValue<String>(
      _AUTHTOKENKEY,
    );
    return token ?? '';
  }
  Future<void> saveUser(UserModel user)async {
  await  saveValue(_USERLOGINDATAKEY, user.toJson().toString()) ;
  }
Future<void>  setOnBoardingSeen(bool seen) async  {
  await  saveValue(_IS_ONBOARDING_SEEN_KEY, seen);
  }

  bool isOnBoardingSeen() {
    return getValue<bool>(_IS_ONBOARDING_SEEN_KEY) ?? false;
  }
  // UserModel getUser(){
  //   return 
  // }
}
