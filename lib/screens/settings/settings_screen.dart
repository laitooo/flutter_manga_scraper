import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/screens/settings/privacy_policy_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';
import 'package:screen/screen.dart';

import 'choose_theme_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ReadingMode mode;
  double brightness;
  bool isNotification;

  @override
  void initState() {
    super.initState();
    mode = prefs.getReadingMode();
    isNotification = prefs.isFavouriteNotification();
    brightness = 0.5;
    loadBrightness();
  }

  loadBrightness() async {
    final _brightness = await Screen.brightness;
    setState(() {
      brightness = _brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _line = SizedBox(
        height: 2,
        child: Divider(
          color: Colors.black,
        ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: ListView(
          children: [
            _settingTitle(Language.of(context).notificationMode, context),
            _settingItem(
                Language.of(context).favouriteMangaNotifications,
                'assets/icons/notification_icon.svg',
                context,
                Switch(
                    activeColor: AppColors.getPrimaryColor(),
                    value: isNotification,
                    onChanged: (value) async {
                      await prefs.setFavouriteNotification(value);
                      setState(() {
                        isNotification = value;
                      });
                    }),
                null),
            _settingTitle(Language.of(context).readingSettings, context),
            _settingItem(
                Language.of(context).chooseTheme,
                'assets/icons/theme_icon.svg',
                context,
                AutoRotate(
                  child: SvgPicture.asset(
                    'assets/icons/next_icon.svg',
                    color: AppColors.getPrimaryColor(),
                    width: 15,
                    height: 15,
                  ),
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChooseThemeScreen()),
              );
            }),
            _line,
            _settingItem(
                Language.of(context).favouriteReadingMode,
                'assets/icons/reading_mode_icon.svg',
                context,
                _readingMode(),
                null),
            _line,
            _settingItem(
                Language.of(context).brightness,
                'assets/icons/brightness_icon.svg',
                context,
                _controlBrightness(),
                null),
            _settingTitle(Language.of(context).aboutTheApp, context),
            _settingItem(
                Language.of(context).currentVersion,
                'assets/icons/current_version_icon.svg',
                context,
                Text(
                  Constants.appVersion,
                  style: TextStyle(
                    color: AppColors.getPrimaryColor(),
                    fontSize: 12,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                null),
            _line,
            _settingItem(
                Language.of(context).lastUpdate,
                'assets/icons/latest_version_icon.svg',
                context,
                Text(
                  Constants.latestUpdate,
                  style: TextStyle(
                    color: AppColors.getPrimaryColor(),
                    fontSize: 12,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                null),
            _line,
            _settingItem(
                Language.of(context).privacyPolicy,
                'assets/icons/privacy_policy_icon.svg',
                context,
                AutoRotate(
                  child: SvgPicture.asset(
                    'assets/icons/next_icon.svg',
                    color: AppColors.getPrimaryColor(),
                    width: 15,
                    height: 15,
                  ),
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _settingTitle(String title, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.unselectedTabColor,
      padding: EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        strutStyle: AppFonts.getStyle(),
      ),
    );
  }

  Widget _settingItem(String itemTitle, String icon, BuildContext context,
      Widget item, Function onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        color: Colors.white,
        padding: EdgeInsetsDirectional.fromSTEB(10, 2, 15, 2),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 12,
              height: 12,
              color: AppColors.getPrimaryColor(),
            ),
            SizedBox(width: 5),
            Text(
              itemTitle,
              style: TextStyle(
                color: AppColors.getPrimaryColor(),
                fontSize: 12,
              ),
              strutStyle: AppFonts.getStyle(),
            ),
            SizedBox(width: 10),
            Spacer(),
            item
          ],
        ),
      ),
    );
  }

  Widget _readingMode() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
            value: ReadingMode.Horizontal,
            groupValue: mode,
            activeColor: AppColors.getAccentColor(),
            onChanged: (value) async {
              await prefs.setReadingMode(value);
              setState(() {
                mode = value;
              });
            }),
        Text(
          Language.of(context).horizontal,
          style: TextStyle(
            color: AppColors.getPrimaryColor(),
            fontSize: 12,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        Radio(
            value: ReadingMode.Vertical,
            groupValue: mode,
            activeColor: AppColors.getAccentColor(),
            onChanged: (value) async {
              await prefs.setReadingMode(value);
              setState(() {
                mode = value;
              });
            }),
        Text(
          Language.of(context).vertical,
          style: TextStyle(
            color: AppColors.getPrimaryColor(),
            fontSize: 12,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
      ],
    );
  }

  Widget _controlBrightness() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/sun_icon.svg',
          color: AppColors.getAccentColor(),
          width: 12,
          height: 12,
        ),
        SizedBox(width: 5),
        Slider(
          value: brightness,
          onChanged: (value) {
            setState(() {
              brightness = value;
            });
            Screen.setBrightness(brightness);
          },
          activeColor: AppColors.getPrimaryColor(),
          inactiveColor: AppColors.getAccentColor(),
        ),
        SizedBox(width: 5),
        SvgPicture.asset(
          'assets/icons/moon_icon.svg',
          color: AppColors.getAccentColor(),
          width: 12,
          height: 12,
        ),
      ],
    );
  }
}
