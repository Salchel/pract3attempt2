import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cat.dart';

class Storage {
  final SharedPreferences _prefs;
  Storage(this._prefs);

  static const _favKey = 'favorites';
  static const _recentKey = 'recent';

  List<Cat> loadFavorites() {
    final raw = _prefs.getStringList(_favKey) ?? [];
    return raw.map((s) => Cat.fromJson(jsonDecode(s))).toList();
  }

  Future<void> saveFavorites(List<Cat> cats) => _prefs.setStringList(
      _favKey, cats.map((c) => jsonEncode(c.toJson())).toList());

  List<String> loadRecent() => _prefs.getStringList(_recentKey) ?? [];

  Future<void> saveRecent(List<String> list) =>
      _prefs.setStringList(_recentKey, list);
}