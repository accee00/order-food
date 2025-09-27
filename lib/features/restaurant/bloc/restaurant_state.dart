part of 'restaurant_bloc.dart';

sealed class RestaurantState extends Equatable {
  final List<Restaurant> restaurants;

  const RestaurantState(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial(super.restaurants);
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading(super.restaurants);
}

class RestaurantLoaded extends RestaurantState {
  const RestaurantLoaded(super.restaurants);
}

class RestaurantDetailLoaded extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantDetailLoaded(this.restaurant, super.restaurants);

  @override
  List<Object> get props => [restaurant, ...super.props];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message, super.restaurants);

  @override
  List<Object> get props => [message, ...super.props];
}
