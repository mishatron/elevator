import 'package:flutter/material.dart';
import 'package:elevator/res/values/strings.dart';
import 'package:elevator/src/core/localization/localization_exception.dart';

class Localization {
  /// [defaultLocaleCode] should be changed if en is not default
  static const defaultLocaleCode = 'uk';

  /// array of supported locale codes, default should be first
  static const localeArray = [defaultLocaleCode];

  /// get list of locales of codes
  static List<Locale> getSupportedLocales() {
    var list = new List<Locale>();
    localeArray.forEach((f) => list.add(Locale(f, '')));
    return list;
  }

  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  /// [localizedValues] map of code and map of values
  static Map<String, Map<String, String>> localizedValues = {'uk': uk};

  /// get value by key in some locale
  String getValue(String key) {
    if (localizedValues.containsKey(locale.languageCode)) {
      if (localizedValues[locale.languageCode].containsKey(key)) {
        return localizedValues[locale.languageCode][key];
      } else
        throw new LocalizationException("No such key:" + key);
    } else {
      throw new LocalizationException("No supported localization");
    }
  }
}
