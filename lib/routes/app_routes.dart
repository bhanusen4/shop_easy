import 'package:ecommerce/data/models/product_model.dart';
import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/product/product_list_screen.dart';
import '../screens/product/product_details_screen.dart';
import '../screens/cart/cart_screen.dart';

class AppRoutes {
  // Route names
  static const splash = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const productList = '/product-list';
  static const productDetails = '/product-details';
  static const cart = '/cart';

  // Route map
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    cart: (_) => const CartScreen(),
  };

  /// For routes that need arguments
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productList:
         final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) =>   ProductListScreen(category:category),
        );

      case productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
