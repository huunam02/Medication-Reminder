import '/lang/vi.dart';

import '/config/global_const.dart';
import '/lang/de.dart';
import '/lang/en.dart';
import '/lang/es.dart';
import '/lang/id.dart';
import '/lang/pt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageUtils extends Translations {
  static const fallbackLocale = Locale('en', 'US');
  static const supportLocale = GlobalConst.supportedLocales;

  static void changeLocale(String languageCode) {
    final locale = _getLocaleFromLanguageCurrent(languageCode: languageCode);
    Get.updateLocale(locale);
    debugPrint(
        'language fo: change locale , languageCode: $languageCode , locale: $locale');
  }

  static Locale _getLocaleFromLanguageCurrent({String? languageCode}) {
    final lang = languageCode ?? Get.deviceLocale!.languageCode;
    for (var i in supportLocale) {
      if (lang == i.languageCode) {
        return i;
      }
    }
    return Get.locale!;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en': enLanguage,
        // 'hi': hiLanguage,
        'es': esLanguage,
        // 'fr': frLanguage,
        'de': deLanguage,
        'id': idLanguage,
        'pt': ptLanguage,
        'vi': viLanguage
      };
}
