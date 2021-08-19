import 'package:flutter/material.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';

class ChapterButton extends StatefulWidget {
  final Chapter chapter;
  final Function onClick;
  final bool isCurrent;

  const ChapterButton({
    Key key,
    this.chapter,
    this.onClick,
    this.isCurrent = false,
  }) : super(key: key);

  @override
  _ChapterButtonState createState() => _ChapterButtonState();
}

class _ChapterButtonState extends State<ChapterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
        setState(() {
          widget.chapter.isWatched = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: widget.isCurrent
              ? Colors.red
              : widget.chapter.isWatched
                  ? Colors.grey
                  : AppColors.getPrimaryColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.chapter.number,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: AppFonts.english,
            ),
            strutStyle: AppFonts.getStyle(),
          ),
        ),
      ),
    );
  }
}
