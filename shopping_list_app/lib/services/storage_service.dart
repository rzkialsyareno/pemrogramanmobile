import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item.dart';

class StorageService {
  static const String _storageKey = 'shopping_items';

  // Save items to local storage
  Future<void> saveItems(List<ShoppingItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving items: $e');
    }
  }

  // Load items from local storage
  Future<List<ShoppingItem>> loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ShoppingItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading items: $e');
      return [];
    }
  }

  // Clear all items from storage
  Future<void> clearItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing items: $e');
    }
  }
}
