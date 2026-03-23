import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'language': 'Language',
      'select_language': 'Select Language',
      'login': 'Login',
    },
    'sw': {
      'language': 'Lugha',
      'select_language': 'Chagua Lugha',
      'login': 'Ingia',
    },
  };

  String get language =>
      _localizedValues[locale.languageCode]!['language']!;

  String get selectLanguage =>
      _localizedValues[locale.languageCode]!['select_language']!;

  String get login =>
      _localizedValues[locale.languageCode]!['login']!;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'sw'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}