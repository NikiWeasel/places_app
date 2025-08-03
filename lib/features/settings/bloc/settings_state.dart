part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  SettingsLoaded({required this.settings});
}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  final String msg;

  SettingsError({required this.msg});
}
