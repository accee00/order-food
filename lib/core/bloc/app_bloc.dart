import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial(isDarkMode: true)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeChanged(isDarkMode: !state.isDarkMode));
    });
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    final isDark = json['isDarkMode'] as bool? ?? true;
    return AppInitial(isDarkMode: isDark);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {'isDarkMode': state.isDarkMode};
  }
}
