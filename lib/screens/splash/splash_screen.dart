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
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.getPrimaryColor(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo6.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 50),
            if (Features.isEnglishEnabled)
              AppButton(
                text: Language.of(context).english,
                borderColor: AppColors.getAccentColor(),
                textColor: AppColors.getAccentColor(),
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
                borderColor: AppColors.getAccentColor(),
                textColor: AppColors.getAccentColor(),
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
