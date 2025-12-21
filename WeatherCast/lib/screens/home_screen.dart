import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/weather_helper.dart';
import '../widgets/weather_info_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'forecast_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialWeather();
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  Future<void> _loadInitialWeather() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    try {
      final lastCity = settingsProvider.getLastCity();
      if (lastCity != null && lastCity.isNotEmpty) {
        await weatherProvider.loadWeatherByCity(lastCity);
      } else {
        // Try to get current location, with timeout
        try {
          await weatherProvider.loadWeatherByCurrentLocation();
        } catch (e) {
          // If location fails, use default city
          await weatherProvider.loadWeatherByCity('Jakarta');
        }
      }
    } catch (e) {
      // Fallback to Jakarta if everything fails
      try {
        await weatherProvider.loadWeatherByCity('Jakarta');
      } catch (e) {
        print('Failed to load initial weather: $e');
      }
    }
  }

  Future<void> _refresh() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherCast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, _) {
          if (weatherProvider.isLoading && weatherProvider.currentWeather == null) {
            return const LoadingWidget();
          }

          if (weatherProvider.error != null && weatherProvider.currentWeather == null) {
            return CustomErrorWidget(
              message: weatherProvider.error!,
              onRetry: _loadInitialWeather,
            );
          }

          if (weatherProvider.currentWeather == null) {
            return const CustomErrorWidget(
              message: 'Tidak ada data cuaca',
            );
          }

          final weather = weatherProvider.currentWeather!;
          final settings = Provider.of<SettingsProvider>(context);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location and Date
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      WeatherHelper.formatDate(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    
                    // Offline mode indicator
                    if (weatherProvider.isOfflineMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Chip(
                          avatar: const Icon(Icons.cloud_off, size: 16),
                          label: const Text('Mode Offline'),
                          backgroundColor: Colors.orange.withOpacity(0.2),
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    
                    const SizedBox(height: 24),

                    // Main Weather Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: weather.getIconUrl(),
                              height: 120,
                              width: 120,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.wb_sunny, size: 120),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              WeatherHelper.formatTemperature(
                                settings.convertTemperature(weather.temperature),
                                showUnit: false,
                              ) + settings.temperatureSymbol,
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              WeatherHelper.capitalize(weather.description),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Terasa seperti ${WeatherHelper.formatTemperature(settings.convertTemperature(weather.feelsLike), showUnit: false)}${settings.temperatureSymbol}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weather Details Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        WeatherInfoCard(
                          icon: Icons.water_drop,
                          label: 'Kelembaban',
                          value: '${weather.humidity}%',
                        ),
                        WeatherInfoCard(
                          icon: Icons.air,
                          label: 'Kecepatan Angin',
                          value: WeatherHelper.formatWindSpeed(weather.windSpeed),
                        ),
                        WeatherInfoCard(
                          icon: Icons.compress,
                          label: 'Tekanan',
                          value: '${weather.pressure} hPa',
                        ),
                        WeatherInfoCard(
                          icon: Icons.visibility,
                          label: 'Jarak Pandang',
                          value: WeatherHelper.formatVisibility(weather.visibility),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sunrise & Sunset
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.wb_sunny, size: 32, color: Colors.orange),
                                const SizedBox(height: 8),
                                const Text('Matahari Terbit'),
                                Text(
                                  WeatherHelper.formatTime(
                                    DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.nightlight, size: 32, color: Colors.indigo),
                                const SizedBox(height: 8),
                                const Text('Matahari Terbenam'),
                                Text(
                                  WeatherHelper.formatTime(
                                    DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // View Forecast Button
                    if (weatherProvider.forecast != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForecastScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Lihat Prakiraan 5 Hari'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
          await weatherProvider.loadWeatherByCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
