import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/order/bloc/order_bloc.dart';
import 'package:order_food/features/restaurant/bloc/restaurant_bloc.dart';
import 'package:order_food/repository/cart_repo.dart';
import 'package:order_food/repository/order_repo.dart';
import 'package:order_food/repository/resturant_repo.dart';

class CustomBlocProviders {
  static get providers => [
    BlocProvider(
      create: (context) =>
          RestaurantBloc(context.read<RestaurantRepository>())
            ..add(LoadRestaurants()),
    ),
    BlocProvider(create: (context) => CartBloc(context.read<CartRepository>())),
    BlocProvider(
      create: (context) => OrderBloc(context.read<OrderRepository>()),
    ),
  ];
}
