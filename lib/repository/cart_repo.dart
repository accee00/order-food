import 'dart:async';
import 'package:order_food/features/cart/model/cart_model.dart';

class CartRepository {
  final List<CartItem> _cartItems = [];

  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_cartItems);
  }

  Future<void> addItem(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final existingIndex = _cartItems.indexWhere(
      (cartItem) =>
          cartItem.menuItem.id == item.menuItem.id &&
          cartItem.restaurantId == item.restaurantId,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + item.quantity,
      );
    } else {
      _cartItems.add(item);
    }
  }

  Future<void> updateItem(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _cartItems.indexWhere(
      (cartItem) =>
          cartItem.menuItem.id == item.menuItem.id &&
          cartItem.restaurantId == item.restaurantId,
    );

    if (index != -1) {
      if (item.quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = item;
      }
    }
  }

  Future<void> removeItem(String menuItemId, String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cartItems.removeWhere(
      (item) =>
          item.menuItem.id == menuItemId && item.restaurantId == restaurantId,
    );
  }

  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cartItems.clear();
  }

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _cartItems.isEmpty ? 0 : 2.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;
}
