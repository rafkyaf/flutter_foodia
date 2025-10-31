// Clean home screen implementing the requested layout (greeting, search, categories, promos, recommended and trending sections).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/order_model.dart';
import '../../../services/notification_service.dart';
import '../../../core/constants/profile_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isDarkMode = false;
  String userName = 'James';

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: _isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Good Morning', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(width: 4),
                Icon(Icons.waving_hand_outlined, color: Colors.amber[600], size: 18),
              ],
            ),
            Text(userName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black87)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: ClipOval(
                child: Image.network(
                  'https://ui-avatars.com/api/?name=$userName&background=random',
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                    radius: 17.5,
                    child: Icon(Icons.person, size: 20),
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.grey),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Builder(builder: (ctx) {
                  final count = context.watch<CartProvider>().items.length;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  );
                }),
              ),
            ],
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined, color: _isDarkMode ? Colors.white : Colors.grey[800]),
            onPressed: () {
              setState(() => _isDarkMode = !_isDarkMode);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 12),
            _buildCategoryTabs(),
            const SizedBox(height: 12),
            _buildPromoCards(),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recommended', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('View more'))
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: products.take(2).map((p) => _recommendedItem(p)).toList(),
              ),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Trending this week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: products.take(4).map((p) => _trendingItem(p)).toList(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.home),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  void _showItemActions(BuildContext context, ProductModel p) {
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
                  final cartProvider = context.read<CartProvider>();
                  cartProvider.add(p);
                  // Check if cart has enough items for direct checkout
                  if (cartProvider.items.length >= 3) { // Example threshold
                    _showCheckoutPrompt(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${p.name} added to cart'),
                      action: SnackBarAction(
                        label: 'Checkout',
                        onPressed: () => _handleCheckout(context),
                      ),
                    ));
                  }
                },
                child: const Text('Add to cart'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleCheckout(context);
                },
                child: const Text('Checkout'),
              ),
            ),
          ])
        ]),
      ),
    );
  }

  void _showCheckoutPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ready to Checkout?'),
        content: const Text('You have several items in your cart. Would you like to checkout now?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);  // Close dialog
              Navigator.pop(context);  // Close bottom sheet
            },
            child: const Text('Continue Shopping'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);  // Close dialog
              Navigator.pop(context);  // Close bottom sheet
              _handleCheckout(context);
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(BuildContext context) async {
    if (!mounted) return;
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    
    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Convert cart items to order items
    final orderItems = cartProvider.items.map((item) => OrderItem(
      name: item.product.name,
      image: item.product.imageUrl,
      price: item.product.price,
      oldPrice: item.product.price, // Using same price as old price for now
      quantity: item.qty,
    )).toList();

    // Create new order
    final order = Order(
      id: DateTime.now().toString(),
      items: orderItems,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    // Create order and clear cart
    await orderProvider.createOrder(order);
    cartProvider.clear();

    // Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to orders screen
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/orders');
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(child: Text('Search beverages or foods', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['Foods', 'Drink', 'Snack', 'Dessert', 'Food'];
    return SizedBox(
      height: 86,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final title = categories[index];
          final isActive = index == 0;
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(color: isActive ? Colors.blue[50] : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: isActive ? Colors.blue : Colors.transparent)),
                width: 64,
                height: 64,
                child: Icon(Icons.fastfood, color: isActive ? Colors.blue : Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromoCards() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final color = i == 0 ? Colors.amber[400] : Colors.red[200];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/orders'),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Happy Weekend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 8),
                Text('60% OFFFor All Menu', style: TextStyle(color: Colors.white)),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _recommendedItem(ProductModel p) {
    return InkWell(
      onTap: () => _showItemActions(context, p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.image, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Row(children: [Icon(Icons.star, size: 16, color: Colors.amber), SizedBox(width: 6), Text('4.6')])])),
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)), child: Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(color: Colors.blue))),
        ]),
      ),
    );
  }

  Widget _trendingItem(ProductModel p) {
    return InkWell(
      onTap: () => _showItemActions(context, p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.fastfood, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('\$${p.price.toStringAsFixed(1)}', style: const TextStyle(color: Colors.red))])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ]),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/notification');
                if (!mounted) return;
                setState(() {});
              },
              icon: const Icon(Icons.notifications_none),
            ),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/orders'), icon: const Icon(Icons.receipt_long)),
            const SizedBox(width: 48), // space for FAB
            // Message icon with unread count
            Builder(builder: (ctx) {
              final unreadMessages = ProfileImages.chatUsers.fold<int>(0, (sum, u) {
                final v = u['unread'];
                if (v == null) return sum;
                return sum + (int.tryParse(v) ?? 0);
              });
              return Stack(
                children: [
                  IconButton(onPressed: () => Navigator.pushNamed(context, '/message'), icon: const Icon(Icons.message_outlined)),
                  if (unreadMessages > 0)
                    Positioned(
                      right: 6,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(unreadMessages.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              );
            }),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: const Icon(Icons.person_outline)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: _isDarkMode ? Colors.grey[900] : Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: Row(children: [
                CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.blue[800], size: 32)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Good Morning', style: TextStyle(color: Colors.white)), Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
              ]),
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.notifications_none), title: const Text('Notifications'), onTap: () => Navigator.pushNamed(context, '/notification')),
            ListTile(leading: const Icon(Icons.person_outline), title: const Text('Profile'), onTap: () => Navigator.pushNamed(context, '/profile')),
            ListTile(
              leading: const Icon(Icons.shopping_cart_checkout),
              title: const Text('Checkout'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _handleCheckout(context);
              },
            ),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () {}),
            const Spacer(),
            SwitchListTile(value: _isDarkMode, onChanged: (v) => setState(() => _isDarkMode = v), title: const Text('Dark Mode'), secondary: const Icon(Icons.nightlight_round)),
          ],
        ),
      ),
    );
  }
      }