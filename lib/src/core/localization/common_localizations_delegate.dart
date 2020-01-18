import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elevator/src/core/localization/app_localizations.dart';

class CommonLocalizationDelegate extends LocalizationsDelegate<Localization> {
  const CommonLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      Localization.localeArray.contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of Localization.
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(CommonLocalizationDelegate old) => false;
}
