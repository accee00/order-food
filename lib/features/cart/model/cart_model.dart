import 'package:equatable/equatable.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';

class CartItem extends Equatable {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;
  final String restaurantId;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    required this.restaurantId,
    this.specialInstructions,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
    String? restaurantId,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  List<Object?> get props => [
    menuItem,
    quantity,
    specialInstructions,
    restaurantId,
  ];
}
