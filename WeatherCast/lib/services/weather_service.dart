import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';
import '../models/city.dart';
import '../utils/constants.dart';

class WeatherService {
  // Get current weather by city name
  Future<Weather> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.weatherEndpoint}'
        '?q=$cityName'
        '&appid=${AppConstants.apiKey}'
        '&units=${AppConstants.unitMetric}'
        '&lang=id',
      );

      print('🌐 Fetching weather for: $cityName');
      print('📡 URL: $url');
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Koneksi timeout. Periksa internet Anda.');
        },
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Kota tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('API key tidak valid');
      } else {
        throw Exception('Gagal mengambil data cuaca (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error: $e');
      
      // Handle different types of network errors with user-friendly messages
      final errorString = e.toString().toLowerCase();
      
      if (errorString.contains('socketexception') || errorString.contains('failed host lookup')) {
        throw Exception('Tidak ada koneksi internet. Periksa WiFi/data Anda.');
      } else if (errorString.contains('timeout')) {
        throw Exception('Koneksi timeout. Coba lagi.');
      } else if (errorString.contains('connection refused')) {
        throw Exception('Server tidak dapat dihubungi. Coba lagi nanti.');
      }
      
      throw Exception('Error: $e');
    }
  }

  // Get current weather by coordinates
  Future<Weather> getCurrentWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.weatherEndpoint}'
        '?lat=$lat'
        '&lon=$lon'
        '&appid=${AppConstants.apiKey}'
        '&units=${AppConstants.unitMetric}'
        '&lang=id',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data cuaca');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get 5-day forecast
  Future<Forecast> getForecast(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.forecastEndpoint}'
        '?lat=$lat'
        '&lon=$lon'
        '&appid=${AppConstants.apiKey}'
        '&units=${AppConstants.unitMetric}'
        '&lang=id',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Forecast.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data forecast');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Search cities by name
  Future<List<City>> searchCities(String query) async {
    try {
      final url = Uri.parse(
        '${AppConstants.geoUrl}${AppConstants.directGeoEndpoint}'
        '?q=$query'
        '&limit=5'
        '&appid=${AppConstants.apiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((city) => City.fromJson(city)).toList();
      } else {
        throw Exception('Gagal mencari kota');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get city name from coordinates (reverse geocoding)
  Future<String> getCityNameFromCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${AppConstants.geoUrl}/reverse'
        '?lat=$lat'
        '&lon=$lon'
        '&limit=1'
        '&appid=${AppConstants.apiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['name'] ?? 'Unknown';
        }
        return 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
