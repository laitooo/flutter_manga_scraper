import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/localization_bloc.dart';
import 'package:manga_scraper/screens/home/home_screen.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/widgets/buttons.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*if (!Features.isEnglishEnabled) {
      BlocProvider.of<LocalizationBloc>(context).add(ChangeLocale('ar'));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }*/

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientSplashStart,
              AppColors.gradientSplashEnd,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 50),
            if (Features.isEnglishEnabled)
              AppButton(
                text: Language.of(context).english,
                borderColor: AppColors.mainColor2,
                textColor: AppColors.mainColor1,
                onClick: () {
                  BlocProvider.of<LocalizationBloc>(context)
                      .add(ChangeLocale('en'));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            SizedBox(height: 10),
            if (Features.isEnglishEnabled)
              AppButton(
                text: Language.of(context).arabic,
                borderColor: AppColors.mainColor2,
                textColor: AppColors.mainColor1,
                onClick: () {
                  BlocProvider.of<LocalizationBloc>(context)
                      .add(ChangeLocale('ar'));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
