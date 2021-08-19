import 'package:flutter/material.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';

class ProgressPercentage extends StatelessWidget {
  final double percentage;
  final double size;
  final double textFont;

  const ProgressPercentage(
      {Key key, this.percentage, this.size = 120, this.textFont = 24})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.getPrimaryColor(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              (percentage * 100).round().toString() + ' %',
              style: TextStyle(
                color: AppColors.getPrimaryColor(),
                fontSize: textFont,
                fontFamily: AppFonts.english,
              ),
              strutStyle: AppFonts.getStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
