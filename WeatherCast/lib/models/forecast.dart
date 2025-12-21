class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pop;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pop: ((json['pop'] ?? 0) * 100).toInt(),
    );
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }
}

class Forecast {
  final String cityName;
  final List<ForecastItem> items;

  Forecast({
    required this.cityName,
    required this.items,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<ForecastItem> items = (json['list'] as List)
        .map((item) => ForecastItem.fromJson(item))
        .toList();

    return Forecast(
      cityName: json['city']['name'] ?? '',
      items: items,
    );
  }

  List<ForecastItem> getHourlyForecast() {
    final now = DateTime.now();
    final next24Hours = now.add(const Duration(hours: 24));
    return items
        .where((item) => item.dateTime.isAfter(now) && item.dateTime.isBefore(next24Hours))
        .toList();
  }

  Map<DateTime, List<ForecastItem>> getDailyForecast() {
    Map<DateTime, List<ForecastItem>> dailyMap = {};
    
    for (var item in items) {
      final date = DateTime(item.dateTime.year, item.dateTime.month, item.dateTime.day);
      if (!dailyMap.containsKey(date)) {
        dailyMap[date] = [];
      }
      dailyMap[date]!.add(item);
    }
    
    return dailyMap;
  }
}
