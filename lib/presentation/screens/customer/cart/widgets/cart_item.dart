import 'package:flutter/material.dart';
import '../../../../../data/models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;
  final double oldPrice;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.product.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 70,
              height: 70,
              color: Colors.grey[100],
              child: Icon(Icons.fastfood, color: Colors.grey[400]),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Coffe, Milk',  // Could be dynamic based on product categories
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${item.product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$$oldPrice',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Quantity Controls
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 20, color: Colors.grey[700]),
                onPressed: () {
                  if (item.qty > 1) {
                    onUpdateQuantity(item.qty - 1);
                  } else {
                    onRemove();
                  }
                },
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${item.qty}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () => onUpdateQuantity(item.qty + 1),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
