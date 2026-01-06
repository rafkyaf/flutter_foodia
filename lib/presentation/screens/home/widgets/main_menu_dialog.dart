import 'package:flutter/material.dart';
import '../../message/message_screen.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../notification/notification_screen.dart';
import '../../profile/customer_profile_screen.dart';
import '../../admin/admin_orders_screen.dart';

class MainMenuDialog extends StatefulWidget {
  const MainMenuDialog({super.key});

  @override
  State<MainMenuDialog> createState() => _MainMenuDialogState();
}

class _MainMenuDialogState extends State<MainMenuDialog> {
  bool _isDarkMode = false;

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    String? badge,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header with avatar and name (tappable)
            Builder(builder: (context) {
              final user = Provider.of<AuthProvider>(context, listen: false).user;
              String displayName = 'Foodia Admin';
              if (user != null) {
                displayName = (user['name'] ?? user['full_name'] ?? user['username'] ?? user['email'] ?? displayName).toString();
              }
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

              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (isAdminRole) {
                    Navigator.pushNamed(context, '/admin/orders');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomerProfileScreen()),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://example.com/henry.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Text(
                                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Good Morning',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Theme toggle button
                      IconButton(
                        icon: const Icon(Icons.dark_mode_outlined),
                        onPressed: () {
                          setState(() {
                            _isDarkMode = !_isDarkMode;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Divider(height: 40),
            // Menu Items
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 24),
                children: [
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    color: Colors.blue[100]!,
                    iconColor: Colors.blue,
                    title: 'Welcome',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.home_outlined,
                    color: Colors.orange[100]!,
                    iconColor: Colors.orange,
                    title: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuItem(
                    icon: Icons.file_copy_outlined,
                    color: Colors.purple[100]!,
                    iconColor: Colors.purple,
                    title: 'Pages',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.grid_view,
                    color: Colors.green[100]!,
                    iconColor: Colors.green,
                    title: 'Components',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_none,
                    color: Colors.red[100]!,
                    iconColor: Colors.red,
                    title: 'Notification',
                    badge: '1',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    color: Colors.indigo[100]!,
                    iconColor: Colors.indigo,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerProfileScreen()),
                      );
                    },
                  ),
                  // Show admin menu only for admin/restaurant users
                  Builder(builder: (context) {
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

                    if (!isAdminRole) return const SizedBox.shrink();

                    return _buildMenuItem(
                      icon: Icons.list_alt,
                      color: Colors.teal[100]!,
                      iconColor: Colors.teal,
                      title: 'Admin Orders',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin/orders');
                      },
                    );
                  }),
                  _buildMenuItem(
                    icon: Icons.chat_bubble_outline,
                    color: Colors.pink[100]!,
                    iconColor: Colors.pink,
                    title: 'Chat',
                    badge: '5',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MessageScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    color: Colors.grey[200]!,
                    iconColor: Colors.grey[700]!,
                    title: 'Logout',
                    onTap: () {
                      // Handle logout: clear auth state and go to login
                      Navigator.pop(context);
                      Provider.of<AuthProvider>(context, listen: false).logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                  const Divider(height: 40),
                  // Settings section
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 16),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    icon: Icons.highlight,
                    color: Colors.amber[100]!,
                    iconColor: Colors.amber,
                    title: 'Highlights',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.dark_mode_outlined,
                    color: Colors.blueGrey[100]!,
                    iconColor: Colors.blueGrey,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                      activeThumbColor: Colors.blue,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}