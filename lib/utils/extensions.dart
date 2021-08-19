import 'package:flutter/material.dart';
import 'package:manga_scraper/theme/app_fonts.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String content,
    int seconds,
  ) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          content,
          strutStyle: AppFonts.getStyle(),
        ),
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
