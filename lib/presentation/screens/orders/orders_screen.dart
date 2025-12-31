import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../core/constants/profile_images.dart';
import '../../../data/models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartCount = cartProvider.items.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Your Orders",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.black87),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search beverages or foods",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔘 Filter Buttons
            // ignore: prefer_const_constructors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                FilterButton(text: "All", selected: false),
                FilterButton(text: "On Delivery", selected: true),
                FilterButton(text: "Completed", selected: false),
              ],
            ),

            const SizedBox(height: 20),

            // 🚚 Order in Delivery
            // ignore: prefer_const_constructors
            OrderCard(
              orderId: "#0012345",
              status: "ON DELIVERY",
              statusColor: Colors.orange,
              statusAction: "Track Location",
              items: const [
                OrderItem(
                  image: "assets/images/coffe_mocha.png",
                  title: "Coffee Mocha / White Mocha",
                  price: 5.0,
                  oldPrice: 8.9,
                  quantity: 2,
                ),
                OrderItem(
                  image: "assets/images/chicken_wings.png",
                  title: "Chicken Wings Spicy",
                  price: 5.0,
                  oldPrice: 8.9,
                  quantity: 2,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ Order Done
            // ignore: prefer_const_constructors
            OrderCard(
              orderId: "#0012345",
              status: "DONE",
              statusColor: Colors.green,
              statusAction: "View Details",
              items: const [
                OrderItem(
                  image: "assets/images/vs cream cb.png",
                  title: "Vanilla Sweet Cream Cold",
                  price: 5.0,
                  oldPrice: 8.9,
                  quantity: 2,
                ),
                OrderItem(
                  image: "assets/images/mily cream.png",
                  title: "Milky Cream Latte",
                  price: 5.0,
                  oldPrice: 8.9,
                  quantity: 2,
                ),
                OrderItem(
                  image: "assets/images/food1.png",
                  title: "BBQ Crispy Wings",
                  price: 5.0,
                  oldPrice: 8.9,
                  quantity: 2,
                ),
              ],
            ),
          ],
        ),
      ),

      // ✅ Copy dari HomeScreen:
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/home'),
        child: const Icon(Icons.home),
      ),
      bottomNavigationBar: BottomAppBar(
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
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/orders'),
                icon: const Icon(Icons.receipt_long),
              ),
              const SizedBox(width: 48), // space for FAB
              Builder(
                builder: (ctx) {
                  final unreadMessages = ProfileImages.chatUsers.fold<int>(0, (sum, u) {
                    final v = u['unread'];
                    if (v == null) return sum;
                    return sum + (int.tryParse(v) ?? 0);
                  });
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/message'),
                        icon: const Icon(Icons.message_outlined),
                      ),
                      if (unreadMessages > 0)
                        Positioned(
                          right: 6,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              unreadMessages.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                icon: const Icon(Icons.person_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool selected;

  const FilterButton({required this.text, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          if (selected)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            text,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.grey.shade600,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final Color statusColor;
  final String statusAction;
  final List<OrderItem> items;

  const OrderCard({
    required this.orderId,
    required this.status,
    required this.statusColor,
    required this.statusAction,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.6,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID $orderId",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    statusAction,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Column(
              children: items.map((item) => item).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final double oldPrice;
  final int quantity;

  const OrderItem({
    required this.image,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "\$${price.toStringAsFixed(1)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "\$${oldPrice.toStringAsFixed(1)}",
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text("x$quantity"),
        ],
      ),
    );
  }
}
