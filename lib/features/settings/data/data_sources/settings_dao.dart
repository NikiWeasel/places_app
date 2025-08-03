import 'package:places_surf/features/settings/domain/entities/settings.dart';
import 'package:places_surf/features/settings/domain/services/i_settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDAO implements ISettingsService {
  final SharedPreferences prefs;

  static const _keyIsDarkTheme = 'is_dark_theme';
  static const _keyDidFinishOnboarding = 'did_finish_onboarding';

  SettingsDAO(this.prefs);

  @override
  Future<Settings> getCurrentSettings() async {
    final isDark = prefs.getBool(_keyIsDarkTheme) ?? false;
    final didFinish = prefs.getBool(_keyDidFinishOnboarding) ?? false;
    return Settings(isDark, didFinish);
  }

  @override
  Future<void> setIsDarkTheme(bool value) async {
    await prefs.setBool(_keyIsDarkTheme, value);
  }

  @override
  Future<void> setDidFinishOnboardingTrue() async {
    await prefs.setBool(_keyDidFinishOnboarding, true);
  }
}
