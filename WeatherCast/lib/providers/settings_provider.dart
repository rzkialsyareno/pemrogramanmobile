import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  
  ThemeMode _themeMode = ThemeMode.system;
  String _temperatureUnit = AppConstants.unitMetric;
  bool _onboardingComplete = false;

  ThemeMode get themeMode => _themeMode;
  String get temperatureUnit => _temperatureUnit;
  bool get onboardingComplete => _onboardingComplete;
  bool get isCelsius => _temperatureUnit == AppConstants.unitMetric;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    final themeModeString = _prefs?.getString(AppConstants.keyThemeMode);
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }

    _temperatureUnit = _prefs?.getString(AppConstants.keyTemperatureUnit) 
        ?? AppConstants.unitMetric;

    _onboardingComplete = _prefs?.getBool(AppConstants.keyOnboardingComplete) ?? false;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setString(AppConstants.keyThemeMode, mode.toString());
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _prefs?.setString(AppConstants.keyTemperatureUnit, unit);
    notifyListeners();
  }

  Future<void> toggleTemperatureUnit() async {
    final newUnit = _temperatureUnit == AppConstants.unitMetric 
        ? AppConstants.unitImperial 
        : AppConstants.unitMetric;
    await setTemperatureUnit(newUnit);
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await _prefs?.setBool(AppConstants.keyOnboardingComplete, true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _onboardingComplete = false;
    await _prefs?.setBool(AppConstants.keyOnboardingComplete, false);
    notifyListeners();
  }

  Future<void> saveLastCity(String cityName) async {
    await _prefs?.setString(AppConstants.keyLastCity, cityName);
  }

  String? getLastCity() {
    return _prefs?.getString(AppConstants.keyLastCity);
  }

  double convertTemperature(double celsius) {
    if (_temperatureUnit == AppConstants.unitImperial) {
      return (celsius * 9 / 5) + 32; // Celsius to Fahrenheit
    }
    return celsius;
  }

  String get temperatureSymbol => isCelsius ? '°C' : '°F';
}
