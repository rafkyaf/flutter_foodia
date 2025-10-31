import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/auth/role_selection_screen.dart';

import 'core/theme/app_theme.dart';
import 'presentation/navigation/app_router.dart';
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
        onGenerateRoute: AppRouter.generateRoute,
        // route awal = splash screen
        initialRoute: '/',
      ),
    );
  }
}
