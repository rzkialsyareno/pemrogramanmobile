import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              // Theme Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tampilan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SwitchListTile(
                  title: const Text('Mode Gelap'),
                  subtitle: const Text('Aktifkan tema gelap'),
                  secondary: Icon(
                    settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  value: settings.isDarkMode,
                  onChanged: (value) {
                    settings.toggleTheme();
                  },
                ),
              ),

              // Temperature Unit Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Satuan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Celsius (°C)'),
                      subtitle: const Text('Satuan metrik'),
                      value: 'metric',
                      groupValue: settings.temperatureUnit,
                      onChanged: (value) {
                        if (value != null) {
                          settings.setTemperatureUnit(value);
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Fahrenheit (°F)'),
                      subtitle: const Text('Satuan imperial'),
                      value: 'imperial',
                      groupValue: settings.temperatureUnit,
                      onChanged: (value) {
                        if (value != null) {
                          settings.setTemperatureUnit(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // About Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tentang',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Versi Aplikasi'),
                      subtitle: const Text('1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cloud),
                      title: const Text('Sumber Data'),
                      subtitle: const Text('OpenWeatherMap API'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Dibuat dengan'),
                      subtitle: const Text('Flutter & Provider'),
                    ),
                  ],
                ),
              ),

              // Developer Info
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.wb_sunny,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'WeatherCast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'UAS Pemrograman Mobile',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
