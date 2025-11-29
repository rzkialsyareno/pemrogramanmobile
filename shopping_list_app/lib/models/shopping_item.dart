import 'dart:convert';

enum Category {
  makanan,
  minuman,
  elektronik,
  pakaian,
  lainnya;

  String get displayName {
    switch (this) {
      case Category.makanan:
        return 'Makanan';
      case Category.minuman:
        return 'Minuman';
      case Category.elektronik:
        return 'Elektronik';
      case Category.pakaian:
        return 'Pakaian';
      case Category.lainnya:
        return 'Lainnya';
    }
  }
}

class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;
  final bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isPurchased = false,
  });

  // Convert ShoppingItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category.name,
      'isPurchased': isPurchased,
    };
  }

  // Create ShoppingItem from JSON
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      category: Category.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => Category.lainnya,
      ),
      isPurchased: json['isPurchased'] as bool? ?? false,
    );
  }

  // Create a copy of ShoppingItem with updated fields
  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    Category? category,
    bool? isPurchased,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
