import 'package:flutter/material.dart';
import 'package:manga_scraper/translation/global_locale.dart';
import 'package:manga_scraper/utils/base_bloc.dart';

class LocalizationBloc extends BaseBloc<LocalizationState> {
  LocalizationBloc() : super(IdleLocalState(lang.locale));
}

class ChangeLocale extends BlocEvent<LocalizationBloc, LocalizationState> {
  final String newLang;

  ChangeLocale(this.newLang);

  @override
  Stream<LocalizationState> toState(
      LocalizationBloc bloc, LocalizationState current) async* {
    yield ChangingLocalState(current.currentLocale);

    if (lang.isGoodLanguage(newLang)) {
      await lang.changeLanguage(newLang);
      yield IdleLocalState(Locale(newLang));
    } else {
      print('this language is invalid');
      yield LocalErrorState(current.currentLocale);
    }
  }
}

abstract class LocalizationState {
  final Locale currentLocale;
  const LocalizationState(this.currentLocale);
}

class IdleLocalState extends LocalizationState {
  IdleLocalState(Locale currentLocale) : super(currentLocale);
}

class LocalErrorState extends LocalizationState {
  LocalErrorState(Locale currentLocale) : super(currentLocale);
}

class ChangingLocalState extends LocalizationState {
  ChangingLocalState(Locale currentLocale) : super(currentLocale);
}
