import 'package:equatable/equatable.dart';
import 'package:order_food/features/cart/model/cart_model.dart';

enum OrderStatus { placed, confirmed, preparing, onTheWay, delivered }

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final String restaurantId;
  final String restaurantName;
  final String deliveryAddress;
  final DateTime orderTime;
  final DateTime? estimatedDeliveryTime;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const Order({
    required this.id,
    required this.items,
    required this.restaurantId,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.orderTime,
    this.estimatedDeliveryTime,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  Order copyWith({OrderStatus? status, DateTime? estimatedDeliveryTime}) {
    return Order(
      id: id,
      items: items,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      deliveryAddress: deliveryAddress,
      orderTime: orderTime,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      status: status ?? this.status,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    restaurantId,
    restaurantName,
    deliveryAddress,
    orderTime,
    estimatedDeliveryTime,
    status,
    subtotal,
    deliveryFee,
    tax,
    total,
  ];
}
