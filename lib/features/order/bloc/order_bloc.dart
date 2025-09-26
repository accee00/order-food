import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/features/cart/model/cart_model.dart';
import 'package:order_food/features/order/model/order_model.dart';
import 'package:order_food/repository/order_repo.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;

  OrderBloc(this._repository) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadOrderById>(_onLoadOrderById);
    on<LoadOrderHistory>(_onLoadOrderHistory);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderPlacing());
    try {
      final order = await _repository.placeOrder(
        items: event.items,
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        deliveryAddress: event.deliveryAddress,
        subtotal: event.subtotal,
        deliveryFee: event.deliveryFee,
        tax: event.tax,
      );
      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError('Failed to place order: ${e.toString()}'));
    }
  }

  Future<void> _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final order = await _repository.getOrderById(event.orderId);
      if (order != null) {
        emit(OrderLoaded(order));
      } else {
        emit(const OrderError('Order not found'));
      }
    } catch (e) {
      emit(OrderError('Failed to load order: ${e.toString()}'));
    }
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _repository.getOrderHistory();
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderError('Failed to load order history: ${e.toString()}'));
    }
  }
}
