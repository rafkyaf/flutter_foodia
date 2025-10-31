import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
	final String title;
	final IconData icon;
	final bool active;

	const CategoryCard({super.key, this.title = 'Category', this.icon = Icons.fastfood, this.active = false});

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				Container(
					width: 64,
					height: 64,
					decoration: BoxDecoration(
						color: active ? Colors.blue[50] : Colors.grey[100],
						borderRadius: BorderRadius.circular(12),
						border: Border.all(color: active ? Colors.blue : Colors.transparent),
					),
					child: Icon(icon, color: active ? Colors.blue : Colors.grey, size: 28),
				),
				const SizedBox(height: 6),
				Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87)),
			],
		);
	}
}
