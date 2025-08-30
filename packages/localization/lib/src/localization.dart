import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'localization_delegate.dart';
part 'localization_setup.dart';

class Localization {
  Localization(this.locale);

  final Locale locale;

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static const LocalizationsDelegate<Localization> delegate =
      LocalizationDelegate();

  Map<String, String>? _localizedStrings;

  Future<void> load() async {
    String jsonString =
        await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String? translate(String key) => _localizedStrings?[key];

  bool get isEnLocale => locale.languageCode == 'en';
}
