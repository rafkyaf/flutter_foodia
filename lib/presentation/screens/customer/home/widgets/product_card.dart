import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/product_model.dart';
import '../../../../../providers/cart_provider.dart';

class HomeProductCard extends StatelessWidget {
	final ProductModel product;

	const HomeProductCard({super.key, required this.product});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => _showProductSheet(context, product),
			child: Container(
				margin: const EdgeInsets.only(bottom: 12),
				padding: const EdgeInsets.all(12),
				decoration: BoxDecoration(
					color: Colors.white,
					borderRadius: BorderRadius.circular(12),
					// ignore: deprecated_member_use
					boxShadow: [BoxShadow(color: Colors.grey.withAlpha((0.06 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))],
				),
				child: Row(
					children: [
						Container(
							width: 64,
							height: 64,
							decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
							child: product.imageUrl.isNotEmpty
									? ClipRRect(
											borderRadius: BorderRadius.circular(8),
											child: Image.network(product.imageUrl, fit: BoxFit.cover),
										)
									: const Icon(Icons.image, color: Colors.grey),
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
								Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
								const SizedBox(height: 8),
								const Row(children: [Icon(Icons.star, size: 16, color: Colors.amber), SizedBox(width: 6), Text('4.6')]),
							]),
						),
						Container(
							padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
							decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
							child: Text('\$${product.price.toStringAsFixed(1)}', style: const TextStyle(color: Colors.blue)),
						),
					],
				),
			),
		);
	}

	void _showProductSheet(BuildContext context, ProductModel p) {
		showModalBottomSheet(
			context: context,
			builder: (_) => Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
					Row(children: [
						Expanded(child: Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
						Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
					]),
					const SizedBox(height: 12),
					Text(p.description, style: const TextStyle(color: Colors.black54)),
					const SizedBox(height: 16),
					Row(children: [
						Expanded(
							child: ElevatedButton(
								onPressed: () {
									Navigator.pop(context);
									context.read<CartProvider>().add(p);
								},
								child: const Text('Add to cart'),
							),
						),
					])
				]),
			),
		);
	}
}

