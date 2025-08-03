import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/features/settings/domain/entities/settings.dart';
import 'package:places_surf/features/settings/domain/repositories/i_settings_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository _settingsRepository;

  SettingsBloc(this._settingsRepository) : super(SettingsInitial()) {
    on<FetchSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        final settings = await _settingsRepository.getCurrentSettings();
        emit(SettingsLoaded(settings: settings));
      } catch (e) {
        emit(SettingsError(msg: e.toString()));
      }
    });
    on<ToggleTheme>((event, emit) async {
      emit(SettingsLoading());
      try {
        // print('toggling');
        await _settingsRepository.toggleDarkTheme();
        add(FetchSettings());
      } catch (e) {
        emit(SettingsError(msg: e.toString()));
      }
    });
    on<OnboardingFinished>((event, emit) async {
      emit(SettingsLoading());
      try {
        await _settingsRepository.onboardingToTrue();
        add(FetchSettings());
      } catch (e) {
        emit(SettingsError(msg: e.toString()));
      }
    });
  }
}
