import 'package:flutter/material.dart';

// Import semua screen yang akan digunakan dalam routing
import '../screens/auth/role_selection_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/carousel_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/pages/pages_screen.dart';
import '../screens/pages/components_screen.dart';
import '../screens/customer/cart/cart_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/customer_profile_screen.dart';
import '../screens/message/message_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/product/product_list_screen.dart';
import '../screens/error/error_page.dart';
import '../../data/models/product_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case '/carousel':
        return MaterialPageRoute(
          builder: (_) => const CarouselScreen(),
          settings: settings,
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
          settings: settings,
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case '/pages':
        return MaterialPageRoute(
          builder: (_) => const PagesScreen(),
          settings: settings,
        );

      case '/components':
        return MaterialPageRoute(
          builder: (_) => const ComponentsScreen(),
          settings: settings,
        );

      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );

      case '/notification':
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
          settings: settings,
        );

      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
          settings: settings,
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const CustomerProfileScreen(),
          settings: settings,
        );

      case '/message':
        return MaterialPageRoute(
          builder: (_) => const MessageScreen(),
          settings: settings,
        );

      case '/product-detail':
        final args = settings.arguments;
        debugPrint('[Router] /product-detail args: $args');
        if (args is ProductModel) {
          debugPrint('[Router] /product-detail using ProductModel directly (id=${args.id})');
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: args),
            settings: settings,
          );
        }

        if (args is Map && args['product'] != null) {
          debugPrint('[Router] /product-detail using Map product');
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: args['product'] as ProductModel),
            settings: settings,
          );
        }

        debugPrint('[Router] /product-detail no args, showing ErrorPage');
        return MaterialPageRoute(
          builder: (_) => const ErrorPage(title: 'Not Found', message: 'Requested content not found.'),
          settings: settings,
        );

      case '/product':
        return MaterialPageRoute(
          builder: (_) => const ProductListScreen(),
          settings: settings,
        );

      default:
        // Rute fallback jika tidak ditemukan
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('404')),
            body: Center(
              child: Text(
                'Halaman "${settings.name}" tidak ditemukan',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
