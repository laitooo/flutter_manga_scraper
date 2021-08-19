import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/preferences.dart';

class SettingsDialog extends StatelessWidget {
  final ReadingMode mode;
  final Function reloadReader;
  final double brightness;
  final Function(double value) onBrightnessChanged;
  final Function setStateCallback;

  const SettingsDialog(
      {Key key,
      this.mode,
      this.reloadReader,
      this.brightness,
      this.onBrightnessChanged,
      this.setStateCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Language.of(context).readingMode,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 2,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                _readingMode(
                  mode,
                  context,
                  reloadReader,
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 2,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Language.of(context).brightness,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 2,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                _controlBrightness(
                  brightness,
                  onBrightnessChanged,
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 2,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Language.of(context).viewSettings,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  strutStyle: AppFonts.getStyle(),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 2,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: prefs.isDoubleClickToZoom(),
                      onChanged: (value) async {
                        await prefs.setDoubleClickToZoom(value);
                        setStateCallback();
                      },
                      fillColor: MaterialStateProperty.all(Colors.white),
                      checkColor: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      Language.of(context).doubleClickToZoom,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      strutStyle: AppFonts.getStyle(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: prefs.isBlackBackground(),
                      onChanged: (value) async {
                        await prefs.setBlackBackground(value);
                        setStateCallback();
                      },
                      fillColor: MaterialStateProperty.all(Colors.white),
                      checkColor: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      Language.of(context).blackBackground,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      strutStyle: AppFonts.getStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _controlBrightness(
      double brightness, Function(double value) onBrightnessChanged) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/sun_icon.svg',
          color: Colors.white,
          width: 12,
          height: 12,
        ),
        SizedBox(width: 5),
        Slider(
          value: brightness,
          onChanged: onBrightnessChanged,
          activeColor: Colors.white,
          inactiveColor: Colors.white.withOpacity(0.7),
        ),
        SizedBox(width: 5),
        SvgPicture.asset(
          'assets/icons/moon_icon.svg',
          color: Colors.white,
          width: 12,
          height: 12,
        )
      ],
    );
  }

  _readingMode(ReadingMode mode, BuildContext context, Function reloadReader) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
            value: ReadingMode.Vertical,
            groupValue: mode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) async {
              await prefs.setReadingMode(value);
              reloadReader();
            }),
        Text(
          Language.of(context).vertical,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        SizedBox(width: 5),
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset('assets/images/vertical_mode.png'),
        ),
        SizedBox(width: 20),
        Radio(
            value: ReadingMode.Horizontal,
            groupValue: mode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) async {
              await prefs.setReadingMode(value);
              reloadReader();
            }),
        Text(
          Language.of(context).horizontal,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        SizedBox(width: 5),
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset('assets/images/horizontal_mode.png'),
        ),
      ],
    );
  }
}
