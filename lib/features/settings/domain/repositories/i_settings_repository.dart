import 'package:places_surf/features/settings/domain/entities/settings.dart';

abstract interface class ISettingsRepository {
  Future<Settings> getCurrentSettings();

  Future<void> toggleDarkTheme();

  Future<void> onboardingToTrue();
}
