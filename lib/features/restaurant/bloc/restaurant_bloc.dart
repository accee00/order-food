import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/features/restaurant/model/resturant.dart';
import 'package:order_food/repository/resturant_repo.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _repository;
  RestaurantBloc(this._repository) : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<LoadRestaurantById>(_onLoadRestaurantById);
  }
  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final List<Restaurant> restaurants = await _repository.getRestaurants();
      print(restaurants);
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError('Failed to load restaurants: ${e.toString()}'));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final List<Restaurant> restaurants = await _repository.searchRestaurants(
        event.query,
      );
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError('Failed to search restaurants: ${e.toString()}'));
    }
  }

  Future<void> _onLoadRestaurantById(
    LoadRestaurantById event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final Restaurant? restaurant = await _repository.getRestaurantById(
        event.restaurantId,
      );
      if (restaurant != null) {
        emit(RestaurantDetailLoaded(restaurant));
      } else {
        emit(const RestaurantError('Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError('Failed to load restaurant: ${e.toString()}'));
    }
  }
}
