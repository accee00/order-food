part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  final bool isDarkMode;
  const AppState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class AppInitial extends AppState {
  const AppInitial({required super.isDarkMode});
}

class ThemeChanged extends AppState {
  const ThemeChanged({required super.isDarkMode});
}
