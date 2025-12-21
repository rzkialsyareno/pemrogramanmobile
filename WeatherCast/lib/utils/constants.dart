class AppConstants {
  // API Configuration
  static const String apiKey = '42867d2fbd493bf1f1b933853beb27e7';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0';
  
  // API Endpoints
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  static const String directGeoEndpoint = '/direct';
  
  // App Configuration
  static const String appName = 'WeatherCast';
  static const String defaultCity = 'Jakarta';
  static const double defaultLat = -6.2088;
  static const double defaultLon = 106.8456;
  
  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyTemperatureUnit = 'temperature_unit';
  static const String keyLastCity = 'last_city';
  static const String keyOnboardingComplete = 'onboarding_complete';
  
  // Database
  static const String dbName = 'weathercast.db';
  static const int dbVersion = 2; // Increased for weather cache table
  static const String tableFavorites = 'favorites';
  static const String tableWeatherCache = 'weather_cache';
  
  // Units
  static const String unitMetric = 'metric';
  static const String unitImperial = 'imperial';
}
