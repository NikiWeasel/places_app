import 'package:places_surf/features/settings/data/data_sources/settings_dao.dart';
import 'package:places_surf/features/settings/domain/entities/settings.dart';
import 'package:places_surf/features/settings/domain/repositories/i_settings_repository.dart';

class SettingsRepository implements ISettingsRepository {
  final SettingsDAO _settingsDAO;

  SettingsRepository(this._settingsDAO);

  @override
  Future<Settings> getCurrentSettings() async {
    return _settingsDAO.getCurrentSettings();
  }

  @override
  Future<void> toggleDarkTheme() async {
    final settings = await getCurrentSettings();
    print(settings.isDark);

    if (settings.isDark) {
      _settingsDAO.setIsDarkTheme(false);
    } else {
      _settingsDAO.setIsDarkTheme(true);
    }
  }

  @override
  Future<void> onboardingToTrue() async {
    _settingsDAO.setDidFinishOnboardingTrue();
  }
}
