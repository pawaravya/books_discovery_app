import 'dart:convert';

import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/models/search_history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static var customSharedPreferences = AppSharedPreferences();
  SharedPreferences? _prefs;
  final String _ISLOGGEDINKEY = "isUserLoggeIn";
  String _AUTHTOKENKEY = "AccessToken";
  String _USERLOGINDATAKEY = 'userLoginData';
  String _IS_ONBOARDING_SEEN_KEY = "isOnBoardingSeen";
  final String _SEARCH_HISTORY_KEY = "searchHistory"; // List<String>

  Future<void> initPrefs() async {
    return await SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  Future<void> saveValue<T>(String key, T value) async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }

    if (value is String) {
      await _prefs!.setString(key, value);
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

  Future<void> setAuthToken(String token) async {
    await saveValue(_AUTHTOKENKEY, token);
  }

  String getAuthToken() {
    final token = AppSharedPreferences.customSharedPreferences.getValue<String>(
      _AUTHTOKENKEY,
    );
    return token ?? '';
  }

  Future<void> saveUser(UserModel user) async {
    await saveValue(_USERLOGINDATAKEY, user.toJson().toString());
  }

  Future<void> setOnBoardingSeen(bool seen) async {
    await saveValue(_IS_ONBOARDING_SEEN_KEY, seen);
  }

  bool isOnBoardingSeen() {
    return getValue<bool>(_IS_ONBOARDING_SEEN_KEY) ?? false;
  }

   /// Save query → results map
  Future<void> saveSearchQueryAndResults(
    String query,
    List<Book> results,
  ) async {
    final existingMap = await getSearchQueryAndResults();

    existingMap[query] = results;

    // Encode to Map<String, List<String>> where each book is json string
    final encoded = existingMap.map(
      (key, value) => MapEntry(
        key,
        value.map((book) => jsonEncode(book.toJson())).toList(),
      ),
    );

    // Store as a JSON string
    await saveValue(_SEARCH_HISTORY_KEY, jsonEncode(encoded));
  }

  /// Get query → results map
  Future<Map<String, List<Book>>> getSearchQueryAndResults() async {
    final raw = getValue<String>(_SEARCH_HISTORY_KEY); // ✅ must be String
    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) {
      final list = (value as List)
          .map((e) => Book.fromJson(jsonDecode(e as String)))
          .toList();
      return MapEntry(key, list);
    });
  }
}
