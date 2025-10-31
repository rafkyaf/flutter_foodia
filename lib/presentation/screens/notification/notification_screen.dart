import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Contoh data notifikasi
  final List<Map<String, dynamic>> notifications = [
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/alex_profile.jpg",
      "isNew": true,
    },
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/sarah_profile.jpg",
      "isNew": true,
    },
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/mike_profile.jpg",
      "isNew": false,
    },
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/james_profile.jpg",
      "isNew": false,
    },
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/profile6.jpg",
      "isNew": false,
    },
    {
      "name": "Lily MacDonald",
      "message": "Lorem ipsum dolor sit ameet..",
      "time": "12 min ago",
      "image": "assets/images/emily_profile.jpg",
      "isNew": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Notification',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: item['isNew']
                  ? const Color(0xFFB5E8C3) // hijau muda untuk notifikasi baru
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!item['isNew'])
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(item['image']),
                radius: 22,
              ),
              title: Text(
                item['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                item['message'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              trailing: Text(
                item['time'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.black45,
                ),
              ),
            ),
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // misalnya tab ke-4 (notifikasi)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}
