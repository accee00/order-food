import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:order_food/core/bloc/app_bloc.dart';
import 'package:order_food/features/cart/bloc/cart_bloc.dart';
import 'package:order_food/features/order/bloc/order_bloc.dart';
import 'package:order_food/features/restaurant/bloc/restaurant_bloc.dart';
import 'package:order_food/repository/cart_repo.dart';
import 'package:order_food/repository/order_repo.dart';
import 'package:order_food/repository/resturant_repo.dart';
import 'package:path_provider/path_provider.dart';

part 'init_di.dart';
