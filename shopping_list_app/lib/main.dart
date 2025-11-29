import 'package:flutter/material.dart';
import 'models/shopping_item.dart';
import 'services/storage_service.dart';
import 'widgets/item_card.dart';
import 'widgets/add_item_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final StorageService _storageService = StorageService();
  List<ShoppingItem> _items = [];
  Category? _selectedFilter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final items = await _storageService.loadItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _saveItems() async {
    await _storageService.saveItems(_items);
  }

  void _addItem() async {
    final result = await showDialog<ShoppingItem>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (result != null) {
      setState(() {
        _items.add(result);
      });
      await _saveItems();
    }
  }

  void _editItem(ShoppingItem item) async {
    final result = await showDialog<ShoppingItem>(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );

    if (result != null) {
      setState(() {
        final index = _items.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          _items[index] = result;
        }
      });
      await _saveItems();
    }
  }

  void _deleteItem(ShoppingItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _items.removeWhere((i) => i.id == item.id);
      });
      await _saveItems();
    }
  }

  void _toggleItemStatus(ShoppingItem item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item.copyWith(isPurchased: !item.isPurchased);
      }
    });
    _saveItems();
  }

  List<ShoppingItem> get _filteredItems {
    if (_selectedFilter == null) {
      return _items;
    }
    return _items.where((item) => item.category == _selectedFilter).toList();
  }

  int get _purchasedCount => _items.where((item) => item.isPurchased).length;
  int get _notPurchasedCount => _items.where((item) => !item.isPurchased).length;

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Belanja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Statistics Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Total',
                  _items.length.toString(),
                  Colors.blue,
                  Icons.shopping_basket,
                ),
                _buildStatCard(
                  'Sudah Dibeli',
                  _purchasedCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
                _buildStatCard(
                  'Belum Dibeli',
                  _notPurchasedCount.toString(),
                  Colors.orange,
                  Icons.pending,
                ),
              ],
            ),
          ),
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Semua'),
                    selected: _selectedFilter == null,
                    onSelected: (_) {
                      setState(() => _selectedFilter = null);
                    },
                  ),
                ),
                ...Category.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.displayName),
                      selected: _selectedFilter == category,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter =
                              _selectedFilter == category ? null : category;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          // Items List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFilter == null
                                  ? 'Belum ada item\nTambahkan item pertama Anda!'
                                  : 'Tidak ada item di kategori ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return ItemCard(
                            item: item,
                            onToggle: () => _toggleItemStatus(item),
                            onEdit: () => _editItem(item),
                            onDelete: () => _deleteItem(item),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Item'),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
