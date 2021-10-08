import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/utils/constants.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:manga_scraper/widgets/auto_rotate.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';
import 'package:manga_scraper/widgets/progress_percentage.dart';
import 'package:path_provider/path_provider.dart';

class DownloadView extends StatelessWidget {
  final DownloadData download;
  final bool isSelected;
  final Function onClick;
  final Function onChapterClick;
  final Function onDeleteClick;
  final Function onRetryClick;
  final Function(bool) onCheckChange;
  bool get isSuccess =>
      !download.hasFailed &&
      !download.isDownloading &&
      download.images == download.progress;

  const DownloadView({
    Key key,
    this.download,
    this.isSelected,
    this.onClick,
    this.onChapterClick,
    this.onDeleteClick,
    this.onRetryClick,
    this.onCheckChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.blueAccent.withOpacity(0.1),
          child: Row(
            children: [
              Checkbox(value: isSelected, onChanged: onCheckChange),
              GestureDetector(
                onTap: onClick,
                child: (download.hasCover && !Features.isMockMoor)
                    ? FutureBuilder<File>(
                        future: _generateCoverFile(download),
                        builder: (context, image) {
                          return image.hasData
                              ? Image(
                                  image: FileImage(image.data),
                                  width: 30,
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                              : Container(
                                  width: 30,
                                  height: 50,
                                );
                        })
                    : Image(
                        image: download.hasCover
                            ? AssetImage(generator.mangaCoverAsset())
                            : (Features.isMockHttp
                                ? AssetImage(generator.mangaCoverAsset())
                                : NetworkImage(download.cover)),
                        width: 30,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onClick,
                      child: Text(
                        download.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.getPrimaryColor(),
                          fontSize: 14,
                          fontFamily: AppFonts.english,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: isSuccess ? onChapterClick : null,
                      child: Container(
                        width: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.getPrimaryColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            download.number,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: AppFonts.english,
                            ),
                            strutStyle: AppFonts.getStyle(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              ..._showDownloadWidgets(),
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 0.5,
          color: Colors.black.withOpacity(0.8),
        )
      ],
    );
  }

  Future<File> _generateCoverFile(DownloadData download) async {
    final extPath = (await getExternalStorageDirectory()).path;
    final path = "$extPath/${Constants.rootDir}/${Constants.downloadsDir}/" +
        "${download.name}/cover.jpg";
    return File(path);
  }

  _showDownloadWidgets() {
    if (download.hasFailed) {
      return [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SvgPicture.asset(
              'assets/icons/reload_icon.svg',
              color: AppColors.getPrimaryColor(),
              width: 40,
              height: 40,
            ),
          ),
          onTap: onRetryClick,
        ),
      ];
    } else {
      if (download.isDownloading) {
        return [
          ProgressPercentage(
            percentage: download.progress / download.images,
            size: 46,
            textFont: 14,
          ),
          SizedBox(width: 10),
        ];
      } else {
        if (download.images == download.progress) {
          return [
            IconButton(
              onPressed: onClick,
              icon: AutoRotate(
                child: SvgPicture.asset(
                  'assets/icons/next_icon.svg',
                  color: AppColors.getPrimaryColor(),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDeleteClick,
              child: Container(
                color: Colors.red,
                width: 30,
                height: 50,
                child: SvgPicture.asset(
                  'assets/icons/delete_icon.svg',
                  color: Colors.white,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ];
        } else {
          return [
            AppProgressIndicator.custom(size: 40),
          ];
        }
      }
    }
  }
}
