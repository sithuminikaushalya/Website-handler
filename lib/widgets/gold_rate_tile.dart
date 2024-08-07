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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: ListTile(
        leading: ClipOval(
          child: goldRate.imagePath.isNotEmpty
              ? Image.network(
                  goldRate.imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                )
              : const Icon(Icons.image, size: 50),
        ),
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
      ),
    );
  }
}
