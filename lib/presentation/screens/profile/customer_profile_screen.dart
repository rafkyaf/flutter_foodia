import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final displayName = user != null ? (user['name'] ?? user['full_name'] ?? user['email'] ?? 'User') : 'Guest';
    final email = user != null ? (user['email'] ?? '') : '';
    bool isAdmin = false;
    if (user != null) {
      final r = user['role'] ?? user['role_name'] ?? user['type'];
      if (r is String && r.toLowerCase().contains('admin')) isAdmin = true;
      if (user['isAdmin'] == true || user['is_admin'] == true) isAdmin = true;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle edit profile
            },
            child: Text(
              'Edit',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight + 32,
        ),
        child: Column(
          children: [
            // Profile Header with Image
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: user != null && (user['avatar'] != null && user['avatar'].toString().isNotEmpty)
                              ? Image.network(
                                  user['avatar'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.grey[200],
                                    child: Text(
                                      displayName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.grey[200],
                                  child: Text(
                                    displayName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAdmin ? 'ADMIN' : 'GOLD MEMBER',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isAdmin ? Colors.redAccent : const Color(0xFFFFD700),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact Information
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contacts',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle edit contacts
                        },
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'Mobile Phone',
                    value: user != null ? (user['phone'] ?? user['mobile'] ?? '+12 345 678 92') : '+12 345 678 92',
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: email.isNotEmpty ? email : 'not-set@example.com',
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: user != null ? (user['address'] ?? 'Not set') : 'Not set',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rewards Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Reward',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.card_giftcard,
                            color: Color(0xFFFFD700),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Show reward history
                        },
                        child: Text(
                          'History',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRewardItem(
                    title: 'Order 10 packs French Fries Deluxe',
                    points: '150',
                    date: '4 days ago',
                  ),
                  const SizedBox(height: 12),
                  _buildRewardItem(
                    title: 'Order French Fries Deluxe',
                    points: '150',
                    date: '4 days ago',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/notification'),
                icon: const Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/orders'),
                icon: const Icon(Icons.receipt_long),
              ),
              const SizedBox(width: 48), // space for FAB
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/message'),
                icon: const Icon(Icons.message_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_outline, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/home'),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(
                25), // Changed from withOpacity(0.1) to withAlpha(25)
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardItem({
    required String title,
    required String points,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  points,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Pts',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
