import 'package:flutter/material.dart';
import '../models/gold_rate.dart';

class GoldRateTile extends StatelessWidget {
  final GoldRate goldRate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoldRateTile({
    required this.goldRate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: goldRate.imagePath.isNotEmpty
          ? Image.network(goldRate.imagePath)
          : const Icon(Icons.image),
      title: Text(goldRate.itemSize),
      subtitle: Text('Price: ${goldRate.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
