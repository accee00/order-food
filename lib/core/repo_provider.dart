import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/repository/cart_repo.dart';
import 'package:order_food/repository/order_repo.dart';
import 'package:order_food/repository/resturant_repo.dart';

class CustomRepoProviders {
  static get providers => [
    RepositoryProvider<RestaurantRepository>(
      create: (context) => RestaurantRepository(),
    ),
    RepositoryProvider<CartRepository>(create: (context) => CartRepository()),
    RepositoryProvider<OrderRepository>(create: (context) => OrderRepository()),
  ];
}
