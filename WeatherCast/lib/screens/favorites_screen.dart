import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../models/favorite_city.dart';
import '../widgets/loading_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  Future<void> _addCurrentCityToFavorites() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

    if (weatherProvider.currentWeather == null) {
      _showSnackBar('Tidak ada data cuaca untuk ditambahkan');
      return;
    }

    final weather = weatherProvider.currentWeather!;
    final favoriteCity = FavoriteCity(
      name: weather.cityName,
      lat: weather.lat ?? 0,
      lon: weather.lon ?? 0,
      country: 'Indonesia',
    );

    final success = await favoritesProvider.addFavorite(favoriteCity);
    if (success) {
      _showSnackBar('${weather.cityName} ditambahkan ke favorit');
    } else {
      _showSnackBar(favoritesProvider.error ?? 'Gagal menambahkan favorit');
    }
  }

  Future<void> _removeFavorite(FavoriteCity city) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Favorit'),
        content: Text('Hapus ${city.name} dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && city.id != null) {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      final success = await favoritesProvider.removeFavorite(city.id!);
      if (success) {
        _showSnackBar('${city.name} dihapus dari favorit');
      }
    }
  }

  Future<void> _selectFavorite(FavoriteCity city) async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    // Use loadWeatherByCity instead of coordinates for offline cache support
    await weatherProvider.loadWeatherByCity(city.name);
    await settingsProvider.saveLastCity(city.name);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kota Favorit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCurrentCityToFavorites,
            tooltip: 'Tambah kota saat ini',
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          if (favoritesProvider.isLoading) {
            return const LoadingWidget();
          }

          if (favoritesProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada kota favorit',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan kota favorit dengan menekan tombol +',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final city = favoritesProvider.favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: Key(city.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Favorit'),
                        content: Text('Hapus ${city.name} dari favorit?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    if (city.id != null) {
                      favoritesProvider.removeFavorite(city.id!);
                      _showSnackBar('${city.name} dihapus dari favorit');
                    }
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.location_city, color: Colors.white),
                    ),
                    title: Text(
                      city.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(city.country ?? 'Indonesia'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _selectFavorite(city),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
