part of 'di_imports.dart';

GetIt serviceLocator = GetIt.instance;

void initDi() {
  /// Repository Locator.
  serviceLocator
    ..registerLazySingleton<RestaurantRepository>(() => RestaurantRepository())
    ..registerLazySingleton<CartRepository>(() => CartRepository())
    ..registerLazySingleton(() => OrderRepository())
    /// Bloc Locator
    ..registerFactory(() => CartBloc(serviceLocator<CartRepository>()))
    ..registerFactory(() => OrderBloc(serviceLocator<OrderRepository>()))
    ..registerFactory(
      () => RestaurantBloc(serviceLocator<RestaurantRepository>()),
    );
}
