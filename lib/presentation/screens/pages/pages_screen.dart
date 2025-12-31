import 'package:flutter/material.dart';

import '../customer/customer_home_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/customer_profile_screen.dart';
import '../splash_screen.dart';
import '../auth/signup_screen.dart';
import '../auth/login_screen.dart';
import '../message/message_screen.dart';
import '../message/chat_screen.dart';
import 'package:flutter_foodia/core/constants/profile_images.dart';
import '../payment/payment_screen.dart';
import '../payment/payment_success_screen.dart';
import '../product/product_detail_screen.dart';
import '../error/error_page.dart';
import 'package:flutter_foodia/data/models/product_model.dart';
import 'components_screen.dart';


class PagesScreen extends StatelessWidget {
  const PagesScreen({super.key});

  static final List<Map<String, Object?>> _items = [
    {'title': 'Home', 'icon': Icons.home, 'route': '/home'},
    {'title': 'Welcome', 'icon': Icons.favorite, 'route': '/login'},
    {'title': 'Profile', 'icon': Icons.person, 'route': '/profile'},
    {'title': 'Product', 'icon': Icons.grid_view, 'route': '/product'},
    {'title': 'Product Detail', 'icon': Icons.info_outline, 'route': '/product-detail'},
    {'title': 'Payment', 'icon': Icons.account_balance_wallet, 'widget': PaymentScreen()},
    {'title': 'Payment Confirm', 'icon': Icons.check_circle_outline, 'widget': PaymentSuccessScreen()},
    {'title': 'Checkout', 'icon': Icons.shopping_bag, 'route': '/cart'},
    {'title': 'Order List', 'icon': Icons.list_alt, 'route': '/orders'},
    {'title': 'Login', 'icon': Icons.login, 'route': '/login'},
    {'title': 'Messages List', 'icon': Icons.message, 'widget': ChatScreen(user: ProfileImages.chatUsers[0])},
    {'title': 'Messages', 'icon': Icons.chat, 'route': '/message'},
    {'title': 'Notification', 'icon': Icons.notifications, 'route': '/notification'},
    {'title': 'Onboarding', 'icon': Icons.auto_stories, 'widget': SplashScreen()},
    {'title': 'Sign Up', 'icon': Icons.person_add, 'widget': SignUpScreen()},
    {'title': 'Error Page', 'icon': Icons.error_outline, 'widget': ErrorPage(title: 'Not Found', message: 'Requested content not found.')},

  ];

  void _open(BuildContext context, Map<String, Object?> item) {
    // Debug info
    debugPrint('[Pages] open item: ${item['title']} route=${item['route']} widget=${item['widget'] is Widget}');

    // Special-case: open ChatScreen directly for "Messages List"
    if ((item['title'] as String?) == 'Messages List') {
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => ChatScreen(user: ProfileImages.chatUsers[0])));
      return;
    }

    // Prefer route string, then widget, otherwise show placeholder
    if (item['route'] is String) {
      final route = item['route'] as String;
      // When navigating to product detail directly, provide a sample product so the screen shows content
      if (route == '/product-detail') {
        final sample = ProductModel(
          id: 'sample',
          name: 'Sample Product',
          description: 'Demo product opened from Pages -> Product Detail',
          price: 6.5,
          imageUrl: 'https://images.unsplash.com/photo-1604908177076-5fe5e3bd0d57?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.0.3&s=',
        );
        Navigator.pushNamed(context, route, arguments: sample);
        return;
      }

      Navigator.pushNamed(context, route);
      return;
    }

    if (item['widget'] is Widget) {
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => item['widget'] as Widget));
      return;
    }

    // Fallback - show ErrorPage for missing widgets
    debugPrint('[Pages] showing ErrorPage for ${item['title']}');
    Navigator.of(context).push(MaterialPageRoute(builder: (c) => ErrorPage(title: item['title'] as String, message: 'Requested content not found.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Pages', style: TextStyle(color: Colors.black87)),
      ),
      backgroundColor: const Color(0xFFF5F7FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: _items.length,
            separatorBuilder: (context, index) => const Divider(height: 8, thickness: 1, color: Color(0xFFF0F0F0)),
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF6F8FA),
                  child: Icon(item['icon'] as IconData, color: const Color(0xFF6B7280), size: 20),
                ),
                title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA0AA)),
                onTap: () => _open(context, item),
              );
            },
          ),
        ),
      ),
    );
  }
}


