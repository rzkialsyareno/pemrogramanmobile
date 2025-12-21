import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/database_helper.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Weather? _currentWeather;
  Forecast? _forecast;
  bool _isLoading = false;
  String? _error;
  String _currentCity = 'Jakarta';
  bool _isOfflineMode = false;

  Weather? get currentWeather => _currentWeather;
  Forecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;
  bool get isOfflineMode => _isOfflineMode;

  Future<void> loadWeatherByCity(String cityName) async {
    _isLoading = true;
    _error = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _currentCity = _currentWeather?.cityName ?? cityName;
      
      await _saveWeatherToCache(_currentWeather!);
      
      if (_currentWeather?.lat != null && _currentWeather?.lon != null) {
        await loadForecast(_currentWeather!.lat!, _currentWeather!.lon!);
      }
      
      _error = null;
    } catch (e) {
      final cachedData = await _dbHelper.getCachedWeather(cityName);
      if (cachedData != null) {
        _currentWeather = _weatherFromCache(cachedData);
        _currentCity = _currentWeather?.cityName ?? cityName;
        _isOfflineMode = true;
        _error = 'Menampilkan data offline (terakhir diupdate: ${_formatCacheTime(cachedData['cached_at'])})';
      } else {
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('socketexception') || errorString.contains('failed host lookup') || errorString.contains('timeout')) {
          _error = 'Anda sedang offline. Data untuk $cityName belum tersedia.\n\nNyalakan internet untuk mengambil data terbaru.';
        } else {
          _error = e.toString().replaceAll('Exception: ', '');
        }
        _currentWeather = null;
        _forecast = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveWeatherToCache(Weather weather) async {
    try {
      await _dbHelper.saveWeatherCache({
        'city_name': weather.cityName,
        'temperature': weather.temperature,
        'description': weather.description,
        'icon': weather.icon,
        'feels_like': weather.feelsLike,
        'humidity': weather.humidity,
        'wind_speed': weather.windSpeed,
        'pressure': weather.pressure,
        'visibility': weather.visibility,
        'sunrise': weather.sunrise,
        'sunset': weather.sunset,
        'lat': weather.lat,
        'lon': weather.lon,
        'cached_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to save cache: $e');
    }
  }

  Weather _weatherFromCache(Map<String, dynamic> cache) {
    return Weather(
      cityName: cache['city_name'],
      temperature: cache['temperature'],
      description: cache['description'],
      icon: cache['icon'],
      feelsLike: cache['feels_like'],
      humidity: cache['humidity'],
      windSpeed: cache['wind_speed'],
      pressure: cache['pressure'],
      visibility: cache['visibility'],
      sunrise: cache['sunrise'],
      sunset: cache['sunset'],
      lat: cache['lat'],
      lon: cache['lon'],
    );
  }

  String _formatCacheTime(String isoString) {
    final cacheTime = DateTime.parse(isoString);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }

  Future<void> loadWeatherByCoordinates(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(lat, lon);
      _currentCity = _currentWeather?.cityName ?? 'Unknown';
      
      if (_currentWeather != null) {
        await _saveWeatherToCache(_currentWeather!);
      }
      
      await loadForecast(lat, lon);
      
      _error = null;
    } catch (e) {
      if (_currentCity.isNotEmpty && _currentCity != 'Unknown') {
        final cachedData = await _dbHelper.getCachedWeather(_currentCity);
        if (cachedData != null) {
          _currentWeather = _weatherFromCache(cachedData);
          _isOfflineMode = true;
          _error = 'Menampilkan data offline (terakhir diupdate: ${_formatCacheTime(cachedData['cached_at'])})';
        } else {
          final errorString = e.toString().toLowerCase();
          if (errorString.contains('socketexception') || errorString.contains('failed host lookup') || errorString.contains('timeout')) {
            _error = 'Anda sedang offline.\n\nNyalakan internet untuk mengambil data lokasi terkini.';
          } else {
            _error = e.toString().replaceAll('Exception: ', '');
          }
          _currentWeather = null;
          _forecast = null;
        }
      } else {
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('socketexception') || errorString.contains('failed host lookup') || errorString.contains('timeout')) {
          _error = 'Anda sedang offline.\n\nNyalakan internet untuk mengambil data lokasi terkini.';
        } else {
          _error = e.toString().replaceAll('Exception: ', '');
        }
        _currentWeather = null;
        _forecast = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadForecast(double lat, double lon) async {
    try {
      _forecast = await _weatherService.getForecast(lat, lon);
    } catch (e) {
      print('Error loading forecast: $e');
      _forecast = null;
    }
  }

  Future<void> loadWeatherByCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPositionWithTimeout();
      
      if (position != null) {
        await loadWeatherByCoordinates(position.latitude, position.longitude);
      } else {
        throw Exception('Tidak dapat mengambil lokasi. Menggunakan lokasi default.');
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      await loadWeatherByCity('Jakarta');
    }
  }

  Future<void> refresh() async {
    await loadWeatherByCity(_currentCity);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
