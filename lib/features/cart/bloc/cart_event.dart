part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;

  const AddToCart(this.item);

  @override
  List<Object> get props => [item];
}

class UpdateCartItem extends CartEvent {
  final CartItem item;

  const UpdateCartItem(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String menuItemId;
  final String restaurantId;

  const RemoveFromCart(this.menuItemId, this.restaurantId);

  @override
  List<Object> get props => [menuItemId, restaurantId];
}

class ClearCart extends CartEvent {}
