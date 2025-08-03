part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class FetchSettings extends SettingsEvent {}

class ToggleTheme extends SettingsEvent {}

class OnboardingFinished extends SettingsEvent {}
