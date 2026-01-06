import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_card.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/auth_provider.dart';

class CustomerHomeScreen extends StatelessWidget {
	const CustomerHomeScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final products = context.watch<ProductProvider>().products;
		final loading = context.watch<ProductProvider>().loading;

		return Scaffold(
			appBar: AppBar(title: const Text('Foodia Home')),
			body: loading
					? const Center(child: CircularProgressIndicator())
					: SingleChildScrollView(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									const SizedBox(height: 12),
									SizedBox(
										height: 100,
										child: ListView(scrollDirection: Axis.horizontal, children: List.generate(6, (i) => const CategoryCard(title: 'Category'))),
									),
									const Padding(
										padding: EdgeInsets.all(12.0),
										child: Text('Trending', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
									),
									GridView.count(
										crossAxisCount: 2,
										shrinkWrap: true,
										physics: const NeverScrollableScrollPhysics(),
										childAspectRatio: 0.7,
										children: products.map((p) => ProductCard(product: p)).toList(),
									),
								],
							),
						),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.shopping_cart),
				onPressed: () {
					final user = Provider.of<AuthProvider>(context, listen: false).user;
					bool isAdminRole = false;
					if (user != null) {
						final roleVal = user['role'] ?? user['type'] ?? user['role_name'] ?? user['is_admin'] ?? user['isAdmin'] ?? user['role_id'];
						final r = roleVal?.toString().toLowerCase();
						if (r == 'admin' || r == 'restaurant' || r == 'true') {
							isAdminRole = true;
						} else {
							final rvnum = int.tryParse(r ?? '');
							if (rvnum != null && rvnum != 1) isAdminRole = true;
						}
					}
					if (isAdminRole) {
						Navigator.of(context).pushNamed('/admin/orders');
					} else {
						Navigator.of(context).pushNamed('/cart');
					}
				},
			),
		);
	}
}