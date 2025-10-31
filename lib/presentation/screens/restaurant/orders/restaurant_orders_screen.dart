import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  String selectedTab = "On Delivery";

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'id': '#0012345',
        'status': 'ON DELIVERY',
        'items': [
          {
            'name': 'Coffee Mocha / White Mocha',
            'image': 'https://i.imgur.com/hxS5v2Z.png',
            'price': 5.0,
            'oldPrice': 8.9,
            'qty': 2
          },
          {
            'name': 'Chicken Wings Spicy',
            'image': 'https://i.imgur.com/RmXyoGp.png',
            'price': 5.0,
            'oldPrice': 8.9,
            'qty': 2
          }
        ],
      },
      {
        'id': '#0012345',
        'status': 'DONE',
        'items': [
          {
            'name': 'Vanilla Sweet Cream Cold',
            'image': 'https://i.imgur.com/DxtqENh.png',
            'price': 5.0,
            'oldPrice': 8.9,
            'qty': 2
          },
          {
            'name': 'Mily Cream Ice Coffee',
            'image': 'https://i.imgur.com/p3A0rK3.png',
            'price': 5.0,
            'oldPrice': 8.9,
            'qty': 2
          },
          {
            'name': 'Deluxe Burger Spicy',
            'image': 'https://i.imgur.com/IlJmQEU.png',
            'price': 5.0,
            'oldPrice': 8.9,
            'qty': 2
          },
        ],
      },
    ];

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
            child: ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final order = orders[index];
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

                        // Item list
                        Column(
                          children: (order['items'] as List).map((item) {
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
}
