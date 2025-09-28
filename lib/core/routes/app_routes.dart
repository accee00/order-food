part of 'app_routes_import.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String restaurantDetail = '/restaurant-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => MainAppScreen());

      case restaurantDetail:
        final restaurant = settings.arguments as Restaurant;
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case checkout:
        final args = settings.arguments as CheckoutRouteArgs;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            cartItems: args.cartItems,
            subtotal: args.subtotal,
            deliveryFee: args.deliveryFee,
            tax: args.tax,
            total: args.total,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No routes'))),
        );
    }
  }
}

class CheckoutRouteArgs {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  CheckoutRouteArgs({
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });
}
