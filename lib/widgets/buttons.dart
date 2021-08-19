import 'package:flutter/material.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Function onClick;
  final double width;
  final double height;
  final double fontSize;
  final double radius;

  const AppButton(
      {Key key,
      @required this.text,
      this.backgroundColor,
      @required this.textColor,
      @required this.onClick,
      this.width = 150,
      this.height = 40,
      this.radius = 4,
      this.borderColor,
      this.fontSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onClick,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? Colors.grey),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor ?? Colors.transparent),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
      ),
    );
  }
}

class ErrorButton extends StatelessWidget {
  final String error;
  final Color textColor;
  final Color overlayColor;
  final Function(BuildContext context) onClick;

  const ErrorButton(
      {Key key, this.error, this.onClick, this.textColor, this.overlayColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
              overlayColor ?? AppColors.getAccentColor())),
      onPressed: () => onClick(context),
      child: Text(
        error ?? Language.of(context).tryAgain,
        style: TextStyle(
          color: textColor ?? Colors.white,
        ),
        strutStyle: AppFonts.getStyle(),
      ),
    );
  }
}
