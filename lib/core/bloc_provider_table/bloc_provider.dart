import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/core/bloc/app_bloc.dart';
import 'package:order_food/core/di/di_imports.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/order/bloc/order_bloc.dart';
import 'package:order_food/features/restaurant/bloc/restaurant_bloc.dart';

class CustomBlocProviders {
  static get providers => [
    BlocProvider<AppBloc>(create: (_) => serviceLocator<AppBloc>()),
    BlocProvider<RestaurantBloc>(
      create: (_) => serviceLocator<RestaurantBloc>(),
    ),
    BlocProvider<CartBloc>(create: (_) => serviceLocator<CartBloc>()),
    BlocProvider<OrderBloc>(
      create: (_) => serviceLocator<OrderBloc>()..add(LoadOrderHistory()),
    ),
  ];
}
