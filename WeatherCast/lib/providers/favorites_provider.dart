import 'package:flutter/material.dart';
import '../models/favorite_city.dart';
import '../services/database_helper.dart';

class FavoritesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  List<FavoriteCity> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<FavoriteCity> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoritesCount => _favorites.length;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _dbHelper.getAllFavorites();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat favorit: $e';
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addFavorite(FavoriteCity city) async {
    try {
      final exists = await _dbHelper.isFavorite(city.name);
      if (exists) {
        _error = 'Kota sudah ada di favorit';
        notifyListeners();
        return false;
      }

      final newCity = await _dbHelper.addFavorite(city);
      _favorites.insert(0, newCity);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal menambah favorit: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(int id) async {
    try {
      await _dbHelper.deleteFavorite(id);
      _favorites.removeWhere((city) => city.id == id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal menghapus favorit: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavoriteByName(String name) async {
    try {
      await _dbHelper.deleteFavoriteByName(name);
      _favorites.removeWhere((city) => city.name == name);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal menghapus favorit: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFavorite(FavoriteCity city) async {
    try {
      await _dbHelper.updateFavorite(city);
      final index = _favorites.indexWhere((c) => c.id == city.id);
      if (index != -1) {
        _favorites[index] = city;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal mengupdate favorit: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> isFavorite(String cityName) async {
    return await _dbHelper.isFavorite(cityName);
  }

  Future<void> clearAllFavorites() async {
    try {
      await _dbHelper.clearAllFavorites();
      _favorites.clear();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menghapus semua favorit: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
