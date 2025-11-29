import 'package:flutter/material.dart';
import '../models/shopping_item.dart';

class ItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.makanan:
        return Colors.orange;
      case Category.minuman:
        return Colors.blue;
      case Category.elektronik:
        return Colors.purple;
      case Category.pakaian:
        return Colors.pink;
      case Category.lainnya:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(item.category);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Opacity(
        opacity: item.isPurchased ? 0.6 : 1.0,
        child: ListTile(
          leading: Checkbox(
            value: item.isPurchased,
            onChanged: (_) => onToggle(),
            activeColor: Colors.green,
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: item.isPurchased
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryColor, width: 1),
                ),
                child: Text(
                  item.category.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: categoryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Jumlah: ${item.quantity}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Hapus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
