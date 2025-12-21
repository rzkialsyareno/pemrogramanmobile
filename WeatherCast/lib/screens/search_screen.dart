import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../services/weather_service.dart';
import '../models/city.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  
  List<City> _searchResults = [];
  bool _isSearching = false;
  String? _error;

  // Popular Indonesian cities
  final List<Map<String, dynamic>> _popularCities = [
    {'name': 'Jakarta', 'country': 'Indonesia'},
    {'name': 'Surabaya', 'country': 'Indonesia'},
    {'name': 'Bandung', 'country': 'Indonesia'},
    {'name': 'Medan', 'country': 'Indonesia'},
    {'name': 'Semarang', 'country': 'Indonesia'},
    {'name': 'Makassar', 'country': 'Indonesia'},
    {'name': 'Palembang', 'country': 'Indonesia'},
    {'name': 'Yogyakarta', 'country': 'Indonesia'},
    {'name': 'Denpasar', 'country': 'Indonesia'},
    {'name': 'Malang', 'country': 'Indonesia'},
  ];

  Future<void> _searchCities(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final results = await _weatherService.searchCities(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isSearching = false;
        _searchResults = [];
      });
    }
  }

  Future<void> _selectCity(String cityName) async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    await weatherProvider.loadWeatherByCity(cityName);
    await settingsProvider.saveLastCity(cityName);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kota'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kota...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchCities('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _searchCities(value);
              },
            ),
          ),

          // Search Results or Popular Cities
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      )
                    : _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final city = _searchResults[index];
                              return ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Text(city.name),
                                subtitle: Text(city.displayName),
                                onTap: () => _selectCity(city.name),
                              );
                            },
                          )
                        : ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Kota Populer',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              ..._popularCities.map((city) {
                                return ListTile(
                                  leading: const Icon(Icons.location_city),
                                  title: Text(city['name']),
                                  subtitle: Text(city['country']),
                                  onTap: () => _selectCity(city['name']),
                                );
                              }).toList(),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}
