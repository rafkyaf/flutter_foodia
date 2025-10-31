import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order_model.dart';

enum OrderTab { all, onDelivery, completed }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedTab = "On Delivery";
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // Fetch all orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshOrders();
      }
    });
  }

  Future<void> _refreshOrders() async {
    if (selectedTab == 'All') {
      await context.read<OrderProvider>().fetchOrders();
    } else {
      String status = selectedTab.toUpperCase().replaceAll(' ', '_');
      await context.read<OrderProvider>().fetchOrdersByStatus(status);
    }
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    // You can integrate navigation logic here if needed
  }

  void _onTabChanged(String tab) {
    setState(() => selectedTab = tab);
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    
    Widget content;
    if (orderProvider.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (orderProvider.error != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading orders',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _onTabChanged(selectedTab),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      final orders = orderProvider.orders;
      content = Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search beverages or foods',
                prefixIcon: const Icon(Icons.search),
                hintStyle: GoogleFonts.poppins(fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
              ),
            ),
          ),

          // Tabs (left aligned)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'On Delivery', 'Completed']
                  .map((tab) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (tab == 'On Delivery' && selectedTab == tab)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Text(tab,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: selectedTab == tab
                                        ? Colors.white
                                        : Colors.black54,
                                  )),
                            ],
                          ),
                          selected: selectedTab == tab,
                          onSelected: (_) => _onTabChanged(tab),
                          selectedColor: Colors.blueAccent,
                          backgroundColor: Colors.grey.shade200,
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Order List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshOrders,
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your orders will appear here',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: order.status == 'ON_DELIVERY'
                            ? Border.all(color: Colors.orange.shade200, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: order.status == 'ON_DELIVERY'
                                ? const Color.fromRGBO(255, 152, 0, 0.15)
                                : const Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order ID ${order.id}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatOrderDate(order.createdAt),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  order.status == 'ON_DELIVERY' 
                                      ? 'Track Location'
                                      : 'View Details',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500)
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Status and order info
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: order.status == 'COMPLETED'
                                        ? Colors.green.shade50
                                        : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        order.status == 'COMPLETED'
                                            ? Icons.check_circle
                                            : Icons.local_shipping_outlined,
                                        size: 14,
                                        color: order.status == 'COMPLETED'
                                            ? Colors.green.shade700
                                            : Colors.orange.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        order.status == 'COMPLETED'
                                            ? 'Completed'
                                            : 'On Delivery',
                                        style: GoogleFonts.poppins(
                                          color: order.status == 'COMPLETED'
                                              ? Colors.green.shade700
                                              : Colors.orange.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${order.totalItems} items',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Item list
                            Column(
                              children: order.items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.image,
                                          height: 56,
                                          width: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 56,
                                              width: 56,
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.fastfood,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.name,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[800])),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Text(
                                                    "\$${item.price.toStringAsFixed(2)}",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black87)),
                                                const SizedBox(width: 8),
                                                if (item.oldPrice != item.price)
                                                  Text(
                                                    "\$${item.oldPrice.toStringAsFixed(2)}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      decoration:
                                                          TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text('x${item.quantity}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            const Divider(height: 24),

                            // Total amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                );
              },
                    ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Your Order',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: false,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.black)),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Text(
                    '5',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.black)),
        ],
      ),
      body: content,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(128, 128, 128, 0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomNavItem(Icons.notifications_outlined, 0),
                _buildBottomNavItem(Icons.receipt_long_outlined, 1),
                const SizedBox(width: 60), // Space for center button
                _buildBottomNavItem(Icons.message_outlined, 3),
                _buildBottomNavItem(Icons.person_outline, 4),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(33, 150, 243, 0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => _onNavTapped(2),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  String _formatOrderDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
