import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:manga_scraper/blocs/localization_bloc.dart';
import 'package:manga_scraper/blocs/theme_bloc.dart';
import 'package:manga_scraper/screens/splash/splash_screen.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/delegate.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocalizationsDelegate _localizationsDelegate =
      AppLocalizationsDelegate();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocalizationBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocConsumer<LocalizationBloc, LocalizationState>(
        listener: (context, state) {
          if (state is IdleLocalState) {
            _localizationsDelegate.load(state.currentLocale);
          }
        },
        builder: (context, state) {
          print('app started with locale: ' + state.currentLocale.languageCode);
          return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context2, state2) {
            return MaterialApp(
              title: 'Flutter Demo',
              locale: Features.isEnglishEnabled
                  ? state.currentLocale
                  : Locale('ar'),
              supportedLocales: [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: [
                _localizationsDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale?.languageCode == locale?.languageCode &&
                      supportedLocale?.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales?.first;
              },
              theme: Features.isCustomFont
                  ? ThemeData(fontFamily: AppFonts.getAppFont())
                  : null,
              home: SplashScreen(),
            );
          });
        },
      ),
    );
  }
}
