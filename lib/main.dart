import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/core/bloc/app_bloc.dart';
import 'package:order_food/core/bloc_provider_table/bloc_provider.dart';
import 'package:order_food/core/di/di_imports.dart';
import 'package:order_food/core/routes/app_routes_import.dart';
import 'package:order_food/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  runApp(
    MultiBlocProvider(providers: CustomBlocProviders.providers, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food Delivery',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.isDarkMode ? ThemeMode.light : ThemeMode.dark,
          onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings),
          initialRoute: AppRoutes.initialRoute,
        );
      },
    );
  }
}
