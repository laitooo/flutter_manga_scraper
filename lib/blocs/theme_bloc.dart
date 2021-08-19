import 'package:manga_scraper/theme/themes_list.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/preferences.dart';

class ThemeBloc extends BaseBloc<ThemeState> {
  ThemeBloc() : super(IdleTheme());
}

class ChangeTheme extends BlocEvent<ThemeBloc, ThemeState> {
  final int theme;

  ChangeTheme(this.theme);
  @override
  Stream<ThemeState> toState(ThemeBloc bloc, ThemeState current) async* {
    yield ChangingTheme();

    if (theme >= 0 && theme < ThemesList.numThemes) {
      prefs.setTheme(theme);
      yield IdleTheme();
    } else {
      yield ThemeError();
    }
  }
}

abstract class ThemeState {}

class IdleTheme extends ThemeState {}

class ChangingTheme extends ThemeState {}

class ThemeError extends ThemeState {}
