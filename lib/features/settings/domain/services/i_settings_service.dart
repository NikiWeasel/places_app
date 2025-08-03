import 'package:places_surf/features/settings/domain/entities/settings.dart';

abstract interface class ISettingsService {
  Future<Settings> getCurrentSettings();

  Future<void> setIsDarkTheme(bool val);

  Future<void> setDidFinishOnboardingTrue();
}
