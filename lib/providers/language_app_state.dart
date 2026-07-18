import 'package:flutter/foundation.dart';
import 'dart:ui';

class LanguageAppState extends ChangeNotifier {
  String _currentLanguageCode = 'en';

  String get currentLanguageCode => _currentLanguageCode;

  LanguageAppState() {
    _initializeDefaultSystemLanguage();
  }

  /// 🌐 Inspects host runtime environment properties to match user system configurations
  void _initializeDefaultSystemLanguage() {
    try {
      // Pulls the first primary locale from the system device/browser configuration array
      final Locale systemLocale = PlatformDispatcher.instance.locale;
      final String primaryLanguage = systemLocale.languageCode
          .toLowerCase()
          .trim();

      if (primaryLanguage.startsWith('es')) {
        _currentLanguageCode = 'es';
      } else {
        _currentLanguageCode = 'en'; // Standard absolute default fallback
      }
    } catch (e) {
      _currentLanguageCode =
          'en'; // Safety fallback on unexpected environment failures
    }
  }

  /// Updates language preference on explicit user click selections
  void updateLanguage(String newLangCode) {
    final cleanCode = newLangCode.toLowerCase().trim();
    if (cleanCode == 'en' || cleanCode == 'es') {
      if (_currentLanguageCode != cleanCode) {
        _currentLanguageCode = cleanCode;
        notifyListeners(); // 🔔 Dispatches updates down layout widgets instantly
      }
    }
  }
}
