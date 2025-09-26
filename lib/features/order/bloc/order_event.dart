part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final List<CartItem> items;
  final String restaurantId;
  final String restaurantName;
  final String deliveryAddress;
  final double subtotal;
  final double deliveryFee;
  final double tax;

  const PlaceOrder({
    required this.items,
    required this.restaurantId,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
  });

  @override
  List<Object> get props => [
    items,
    restaurantId,
    restaurantName,
    deliveryAddress,
    subtotal,
    deliveryFee,
    tax,
  ];
}

class LoadOrderById extends OrderEvent {
  final String orderId;

  const LoadOrderById(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class LoadOrderHistory extends OrderEvent {}
