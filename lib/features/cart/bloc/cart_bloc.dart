import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/repository/cart_repo.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _respository;

  CartBloc(this._respository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _respository.getCartItems();
      emit(
        CartLoaded(
          items: items,
          subtotal: _respository.subtotal,
          deliveryFee: _respository.deliveryFee,
          tax: _respository.tax,
          total: _respository.total,
        ),
      );
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _respository.addItem(event.item);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _respository.updateItem(event.item);

      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final updatedItems = currentState.items.map((item) {
          if (item.menuItem.id == event.item.menuItem.id) {
            return event.item;
          }
          return item;
        }).toList();

        emit(currentState.copyWith(items: updatedItems));
      }
    } catch (e) {
      emit(CartError('Failed to update cart item: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _respository.removeItem(event.menuItemId, event.restaurantId);

      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final updatedItems = currentState.items
            .where((item) => item.menuItem.id != event.menuItemId)
            .toList();

        emit(currentState.copyWith(items: updatedItems));
      }
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _respository.clearCart();
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }
}
