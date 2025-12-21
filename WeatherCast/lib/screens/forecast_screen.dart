import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../models/forecast.dart';
import '../utils/weather_helper.dart';
import '../widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prakiraan Cuaca'),
      ),
      body: Consumer2<WeatherProvider, SettingsProvider>(
        builder: (context, weatherProvider, settings, _) {
          if (weatherProvider.forecast == null) {
            return const Center(
              child: Text('Tidak ada data prakiraan'),
            );
          }

          final forecast = weatherProvider.forecast!;
          final dailyForecast = forecast.getDailyForecast();
          final hourlyForecast = forecast.getHourlyForecast();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hourly Forecast
                if (hourlyForecast.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Prakiraan Per Jam',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: hourlyForecast.length,
                      itemBuilder: (context, index) {
                        final item = hourlyForecast[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  WeatherHelper.formatHour(item.dateTime),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                CachedNetworkImage(
                                  imageUrl: item.getIconUrl(),
                                  height: 40,
                                  width: 40,
                                  placeholder: (context, url) => const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.wb_sunny, size: 40),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${WeatherHelper.formatTemperature(settings.convertTemperature(item.temperature), showUnit: false)}${settings.temperatureSymbol}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Daily Forecast
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Prakiraan 5 Hari',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dailyForecast.length,
                  itemBuilder: (context, index) {
                    final date = dailyForecast.keys.elementAt(index);
                    final items = dailyForecast[date]!;
                    
                    // Calculate min/max temp for the day
                    final temps = items.map((e) => e.temperature).toList();
                    final minTemp = temps.reduce((a, b) => a < b ? a : b);
                    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
                    
                    // Get midday weather icon (around 12:00)
                    final middayItem = items.firstWhere(
                      (item) => item.dateTime.hour >= 12,
                      orElse: () => items.first,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CachedNetworkImage(
                          imageUrl: middayItem.getIconUrl(),
                          height: 50,
                          width: 50,
                          placeholder: (context, url) => const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.wb_sunny, size: 50),
                        ),
                        title: Text(
                          WeatherHelper.formatDay(date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          WeatherHelper.capitalize(middayItem.description),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${WeatherHelper.formatTemperature(settings.convertTemperature(maxTemp), showUnit: false)}${settings.temperatureSymbol}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${WeatherHelper.formatTemperature(settings.convertTemperature(minTemp), showUnit: false)}${settings.temperatureSymbol}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
