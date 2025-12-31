import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'presentation/screens/auth/role_selection_screen.dart';
import 'presentation/screens/customer/cart/cart_screen.dart';
import 'presentation/screens/payment/payment_screen.dart';

// Core & Navigation
import 'core/theme/app_theme.dart';
import 'presentation/navigation/app_router.dart';

// Providers & Repository
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'repositories/order_repository_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(OrderRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'Foodia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // routing menggunakan AppRouter
        onGenerateRoute: AppRouter.generateRoute,

        // Tambahan route manual agar Cart dan Payment bisa langsung diakses
        routes: {
          '/cart': (_) => const CartScreen(),
          '/payment': (_) => const PaymentScreen(),
        },

        // route awal (misalnya splash screen)
        initialRoute: '/',
      ),
    );
  }
}
