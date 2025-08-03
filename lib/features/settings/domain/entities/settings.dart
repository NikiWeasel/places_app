

class Settings {
  final bool isDark;
  final bool didFinishOnboarding;

  Settings(this.isDark, this.didFinishOnboarding);

  Settings copyWith({bool? isDark, bool? didFinishOnboarding}) {
    return Settings(
      isDark ?? this.isDark,
      didFinishOnboarding ?? this.didFinishOnboarding,
    );
  }
}
