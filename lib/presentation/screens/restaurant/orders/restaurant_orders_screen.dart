import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  String selectedTab = "On Delivery";
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> notifications = [];
  bool loading = false;
  final int adminId = 2; // for demo; replace with auth session value
  final String apiBase = 'http://localhost'; // adjust if needed

  @override
  Widget build(BuildContext context) {
    // use fetched orders if available, otherwise empty list
    final displayOrders = orders.isNotEmpty ? orders : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        title: Text('Your Orders',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: false,
        actions: [
          // Notifications button
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () async {
                  await fetchNotifications();
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => buildNotificationsSheet(),
                  );
                },
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      notifications.length.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
          IconButton(
              onPressed: () async { await fetchOrders(); },
              icon: const Icon(Icons.refresh, color: Colors.black)),
        ],
      ),
      body: Column(
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

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['All', 'On Delivery', 'Completed']
                  .map((tab) => ChoiceChip(
                        label: Text(tab,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: selectedTab == tab
                                  ? Colors.white
                                  : Colors.black54,
                            )),
                        selected: selectedTab == tab,
                        onSelected: (_) => setState(() => selectedTab = tab),
                        selectedColor: Colors.blueAccent,
                        backgroundColor: Colors.grey.shade200,
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Order List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: displayOrders.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final order = displayOrders[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order ID ${order['id']}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            order['status'] == 'ON DELIVERY'
                                ? Text('Track Location',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500))
                                : Text('View Details',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Status
                        Row(
                          children: [
                            Icon(Icons.circle,
                                size: 10,
                                color: order['status'] == 'DONE'
                                    ? Colors.green
                                    : Colors.red),
                            const SizedBox(width: 6),
              Text(order['status'].toString(),
                style: GoogleFonts.poppins(
                  color: order['status'].toString() == 'DONE'
                    ? Colors.green
                    : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Payment status and actions (admin)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment: ${order['payment_status'] ?? 'pending'}',
                                style: GoogleFonts.poppins(
                                    color: order['payment_status'] == 'paid'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.w600),
                              ),
                              if (order['payment_status'] == 'paid')
                                ElevatedButton(
                                  onPressed: () => verifyOrder(order['id'].toString()),
                                  child: const Text('Verify & Queue'),
                                ),
                            ],
                          ),
                        ),

                        // Item list
                        Column(
                          children: getOrderItems(order).map((item) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['image'],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                                "\$${item['price'].toStringAsFixed(1)}",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87)),
                                            const SizedBox(width: 5),
                                            Text(
                                              "\$${item['oldPrice']}",
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
                                  Text('x${item['qty']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
    fetchNotifications();
  }

  Future<void> fetchOrders() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse('$apiBase/api/orders.php'));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j['success'] == true && j['data'] is List) {
          setState(() {
            orders = List<Map<String, dynamic>>.from(j['data']);
          });
        }
      }
    } catch (e) {
      // ignore network errors; keep mock/empty state
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final res = await http.get(Uri.parse('$apiBase/api/notifications.php?admin_id=$adminId'));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j['success'] == true && j['data'] is List) {
          setState(() {
            notifications = List<Map<String, dynamic>>.from(j['data']);
          });
        }
      }
    } catch (e) {}
  }

  List getOrderItems(Map<String, dynamic> order) {
    try {
      if (order['payload'] != null) {
        final pl = order['payload'];
        if (pl is String) {
          final dec = jsonDecode(pl);
          if (dec is Map && dec['items'] != null) return dec['items'];
          if (dec is List) return dec;
        } else if (pl is Map && pl['items'] != null) return pl['items'];
      }
      if (order['items'] != null) return order['items'];
    } catch (e) {}
    return [];
  }

  Future<void> verifyOrder(String orderId) async {
    final uri = Uri.parse('$apiBase/api/orders.php?action=verify');
    try {
      final res = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'order_id': orderId, 'admin_id': adminId}));
      final j = jsonDecode(res.body);
      if (res.statusCode == 200 && j['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order verified')));
        await fetchOrders();
        await fetchNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verify failed: ${j['message'] ?? 'error'}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error')));
    }
  }

  Widget buildNotificationsSheet() {
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Notifications', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                final n = notifications[i];
                return ListTile(
                  title: Text(n['type'] ?? 'notification', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text(n['message'] ?? '', style: GoogleFonts.poppins()),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
