part of 'di_imports.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> initDi() async {
  final HydratedStorage storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationSupportDirectory()).path,
          ),
  );
  HydratedBloc.storage = storage;

  serviceLocator.registerFactory<AppBloc>(() => AppBloc());

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
