import 'dart:async';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/features/order/model/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderRepository {
  final List<Order> _orders = [];
  final _uuid = const Uuid();

  Future<Order> placeOrder({
    required List<CartItem> items,
    required String restaurantId,
    required String restaurantName,
    required String deliveryAddress,
    required double subtotal,
    required double deliveryFee,
    required double tax,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // if (DateTime.now().millisecond % 10 == 0) {
    //   throw Exception('Failed to place order. Please try again.');
    // }

    final order = Order(
      id: _uuid.v4(),
      items: items,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      deliveryAddress: deliveryAddress,
      orderTime: DateTime.now(),
      estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 35)),
      status: OrderStatus.placed,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: subtotal + deliveryFee + tax,
    );

    _orders.add(order);

    _simulateOrderProgress(order.id);

    return order;
  }

  Future<Order?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Order>> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_orders);
  }

  void _simulateOrderProgress(String orderId) {
    Timer(
      const Duration(seconds: 10),
      () => _updateOrderStatus(orderId, OrderStatus.confirmed),
    );
    Timer(
      const Duration(seconds: 30),
      () => _updateOrderStatus(orderId, OrderStatus.preparing),
    );
    Timer(
      const Duration(minutes: 2),
      () => _updateOrderStatus(orderId, OrderStatus.onTheWay),
    );
    Timer(
      const Duration(minutes: 3),
      () => _updateOrderStatus(orderId, OrderStatus.delivered),
    );
  }

  void _updateOrderStatus(String orderId, OrderStatus status) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(status: status);
    }
  }
}
