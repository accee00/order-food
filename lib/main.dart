import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_food/core/bloc_provider_table/bloc_provider.dart';
import 'package:order_food/core/di/di_imports.dart';
import 'package:order_food/core/theme/app_theme.dart';
import 'package:order_food/features/restaurant/presentation/view/main_screen.dart';

void main() {
  initDi();
  runApp(
    MultiBlocProvider(providers: CustomBlocProviders.providers, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      theme: AppTheme.darkTheme,
      home: const MainAppScreen(),
    );
  }
}
