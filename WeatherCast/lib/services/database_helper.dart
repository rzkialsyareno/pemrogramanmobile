import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_city.dart';
import '../utils/constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create favorites table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableFavorites} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        country TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    
    // Create weather cache table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableWeatherCache} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_name TEXT NOT NULL,
        temperature REAL NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        feels_like REAL NOT NULL,
        humidity INTEGER NOT NULL,
        wind_speed REAL NOT NULL,
        pressure INTEGER NOT NULL,
        visibility INTEGER NOT NULL,
        sunrise INTEGER NOT NULL,
        sunset INTEGER NOT NULL,
        lat REAL,
        lon REAL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add weather cache table for version 2
      await db.execute('''
        CREATE TABLE ${AppConstants.tableWeatherCache} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          city_name TEXT NOT NULL,
          temperature REAL NOT NULL,
          description TEXT NOT NULL,
          icon TEXT NOT NULL,
          feels_like REAL NOT NULL,
          humidity INTEGER NOT NULL,
          wind_speed REAL NOT NULL,
          pressure INTEGER NOT NULL,
          visibility INTEGER NOT NULL,
          sunrise INTEGER NOT NULL,
          sunset INTEGER NOT NULL,
          lat REAL,
          lon REAL,
          cached_at TEXT NOT NULL
        )
      ''');
    }
  }

  // CREATE - Add favorite city
  Future<FavoriteCity> addFavorite(FavoriteCity city) async {
    final db = await database;
    final id = await db.insert(
      AppConstants.tableFavorites,
      city.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return city.copyWith(id: id);
  }

  // READ - Get all favorites
  Future<List<FavoriteCity>> getAllFavorites() async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableFavorites,
      orderBy: 'created_at DESC',
    );
    return result.map((map) => FavoriteCity.fromMap(map)).toList();
  }

  // READ - Get favorite by ID
  Future<FavoriteCity?> getFavoriteById(int id) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return FavoriteCity.fromMap(result.first);
    }
    return null;
  }

  // READ - Check if city is favorite
  Future<bool> isFavorite(String name) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableFavorites,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  // UPDATE - Update favorite city
  Future<int> updateFavorite(FavoriteCity city) async {
    final db = await database;
    return await db.update(
      AppConstants.tableFavorites,
      city.toMap(),
      where: 'id = ?',
      whereArgs: [city.id],
    );
  }

  // DELETE - Remove favorite by ID
  Future<int> deleteFavorite(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Remove favorite by name
  Future<int> deleteFavoriteByName(String name) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableFavorites,
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // DELETE - Clear all favorites
  Future<int> clearAllFavorites() async {
    final db = await database;
    return await db.delete(AppConstants.tableFavorites);
  }

  // ===== WEATHER CACHE METHODS =====
  
  // Save weather to cache
  Future<void> saveWeatherCache(Map<String, dynamic> weatherData) async {
    final db = await database;
    
    // Delete old cache for this city
    await db.delete(
      AppConstants.tableWeatherCache,
      where: 'city_name = ?',
      whereArgs: [weatherData['city_name']],
    );
    
    // Insert new cache
    await db.insert(
      AppConstants.tableWeatherCache,
      weatherData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  // Get cached weather by city name
  Future<Map<String, dynamic>?> getCachedWeather(String cityName) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableWeatherCache,
      where: 'city_name = ?',
      whereArgs: [cityName],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  
  // Get last cached weather (any city)
  Future<Map<String, dynamic>?> getLastCachedWeather() async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableWeatherCache,
      orderBy: 'cached_at DESC',
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  
  // Clear all weather cache
  Future<int> clearWeatherCache() async {
    final db = await database;
    return await db.delete(AppConstants.tableWeatherCache);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
