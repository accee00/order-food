part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? tax,
  }) {
    final List<CartItem> updatedItems = items ?? this.items;
    final double updatedSubtotal = updatedItems.fold(
      0,
      (sum, item) => sum + item.menuItem.price * item.quantity,
    );
    final double updatedTax = tax ?? this.tax;
    final double updatedDeliveryFee = deliveryFee ?? this.deliveryFee;
    final double updatedTotal =
        updatedSubtotal + updatedTax + updatedDeliveryFee;

    return CartLoaded(
      items: updatedItems,
      subtotal: updatedSubtotal,
      deliveryFee: updatedDeliveryFee,
      tax: updatedTax,
      total: updatedTotal,
    );
  }

  @override
  List<Object> get props => [items, subtotal, deliveryFee, tax, total];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
