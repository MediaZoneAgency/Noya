import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInitial());

  // Singleton accessor for easier retrieval in the widget tree
  static LocalizationCubit get(BuildContext context) => BlocProvider.of(context);

  // Current locale (default is set to system's locale or a default locale)
  Locale _locale = ui.window.locale; // Default to English

  // Getter for the current locale
  Locale get locale => _locale;

  //Method to change the locale
  void changeLocale(String languageCode) {
    _locale = Locale(languageCode);
    emit(LocalizationChanged(Locale(languageCode))); // Emit the new locale state
  }
  void toggleLanguage() {
  // Toggle between Arabic and English
  if (_locale.languageCode == 'en') {
    _locale = const Locale('ar');
  } else {
    _locale = const Locale('en');
  }
  emit(LocalizationChanged(_locale));
}
}
