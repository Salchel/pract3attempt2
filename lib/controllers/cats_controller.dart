import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/cat_api.dart';
import '../data/storage.dart';
import '../models/cat.dart';

class CatsController extends ChangeNotifier {
  final CatApi _api;
  final Storage _storage;

  CatsController(this._api, this._storage) {
    favorites = _storage.loadFavorites();
    recent = _storage.loadRecent();
  }

  List<Cat> results = [];
  List<Cat> favorites = [];
  List<String> recent = [];
  bool loading = false;
  bool searched = false;
  String? error;

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      results = await _api.searchByName(q);
      searched = true;
      _addRecent(q);
    } on DioException catch (e) {
      results = [];
      error = _mapError(e);
    } catch (_) {
      results = [];
      error = 'Что-то пошло не так';
    }
    loading = false;
    notifyListeners();
  }

  String _mapError(DioException e) {
    if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
      return 'Проверьте API-ключ';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Нет соединения с сетью';
      default:
        return 'Ошибка сервера (${e.response?.statusCode ?? '-'})';
    }
  }

  //последние поиски
  void _addRecent(String q) {
    recent.removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    recent.insert(0, q);
    if (recent.length > 10) recent = recent.sublist(0, 10);
    _storage.saveRecent(recent);
  }

  void removeRecent(String q) {
    recent.remove(q);
    _storage.saveRecent(recent);
    notifyListeners();
  }

  void clearRecent() {
    recent = [];
    _storage.saveRecent(recent);
    notifyListeners();
  }

  //избранное
  bool isFavorite(Cat c) => favorites.any((e) => e.name == c.name);

  void toggleFavorite(Cat c) {
    if (isFavorite(c)) {
      favorites.removeWhere((e) => e.name == c.name);
    } else {
      favorites.insert(0, c);
    }
    _storage.saveFavorites(favorites);
    notifyListeners();
  }
}