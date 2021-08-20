import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/models/manga_detail.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';
import 'package:manga_scraper/widgets/progress_percentage.dart';

class DownloadDialog extends StatelessWidget {
  final MangaDetail mangaDetail;
  final int images;
  final String firstImage;
  final String number;
  final String volume;

  const DownloadDialog({
    Key key,
    @required this.number,
    @required this.mangaDetail,
    @required this.images,
    @required this.volume,
    @required this.firstImage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    sendToServer(context);
    return Builder(
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 250,
            color: Colors.white,
            padding: EdgeInsets.all(8),
            child: StreamBuilder<Map<String, dynamic>>(
              stream: FlutterBackgroundService().onDataReceived.where(
                    (data) =>
                        data['dialog'] &&
                        data['slug'] == mangaDetail.slug &&
                        data['number'] == number,
                  ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final status = snapshot.data['status'] as String;

                  if (status == UiDownloadAction.addedToQueue.toText()) {
                    return _downloadScreen(
                      context,
                      AppProgressIndicator.custom(size: 120),
                      Language.of(context).anotherDownloadInProgress,
                    );
                  }

                  if (status == UiDownloadAction.downloadFailed.toText()) {
                    return _downloadScreen(
                      context,
                      SvgPicture.asset(
                        'assets/icons/current_version_icon.svg',
                        color: AppColors.getPrimaryColor(),
                        width: 120,
                        height: 120,
                      ),
                      Language.of(context).downloadFailed,
                    );
                  }

                  if (status == UiDownloadAction.alreadyDownloaded.toText()) {
                    return _downloadScreen(
                      context,
                      SvgPicture.asset(
                        'assets/icons/check_circle_icon.svg',
                        color: AppColors.getPrimaryColor(),
                        width: 120,
                        height: 120,
                      ),
                      Language.of(context).alreadyDownloaded,
                    );
                  }

                  if (status == UiDownloadAction.downloadCompleted.toText()) {
                    return _downloadScreen(
                      context,
                      SvgPicture.asset(
                        'assets/icons/check_circle_icon.svg',
                        color: AppColors.getPrimaryColor(),
                        width: 120,
                        height: 120,
                      ),
                      Language.of(context).downloadCompleted,
                    );
                  }

                  if (status == UiDownloadAction.progressUpdate.toText()) {
                    int progress = snapshot.data['progress'] as int;
                    return _downloadScreen(
                      context,
                      ProgressPercentage(
                        percentage: progress / images,
                        size: 120,
                      ),
                      Language.of(context).downloading,
                    );
                  }
                }

                return _downloadScreen(
                  context,
                  AppProgressIndicator.custom(size: 120),
                  Language.of(context).downloading,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _downloadScreen(
      BuildContext context, Widget middleWidget, String text) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              'assets/icons/close_icon.svg',
              color: AppColors.getPrimaryColor(),
              width: 25,
              height: 25,
            ),
          ),
        ),
        SizedBox(height: 10),
        middleWidget,
        SizedBox(height: 20),
        Text(
          text,
          style: TextStyle(
            color: AppColors.getPrimaryColor(),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
      ],
    );
  }

  void sendToServer(BuildContext context) async {
    final download = DownloadData(
      slug: mangaDetail.slug,
      name: mangaDetail.name,
      cover: mangaDetail.cover,
      images: images,
      number: number,
      hasCover: false,
      isDownloading: false,
      progress: 0,
      hasFailed: false,
      volume: volume,
      first: firstImage,
    );
    FlutterBackgroundService().sendData({
      'action': ServiceDownloadAction.addDownload.toText(),
      'download': download.toJson(),
    });
  }
}
