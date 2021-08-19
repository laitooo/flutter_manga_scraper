import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/oflline_pages_bloc.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/screens/reader/menu_dialog.dart';
import 'package:manga_scraper/screens/reader/reader_widgets.dart';
import 'package:manga_scraper/screens/reader/settings_dialog.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/utils/share.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screen/screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OfflineReaderScreen extends StatelessWidget {
  final DownloadData download;
  final bool isHorizontal;

  const OfflineReaderScreen(
      {Key key, @required this.download, @required this.isHorizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfflinePagesBloc()
        ..add(
          LoadOfflinePages(download),
        ),
      child: _OfflineReaderScreen(
        download: download,
        isHorizontal: isHorizontal,
      ),
    );
  }
}

class _OfflineReaderScreen extends StatefulWidget {
  final DownloadData download;
  final bool isHorizontal;

  const _OfflineReaderScreen({Key key, this.download, this.isHorizontal})
      : super(key: key);

  @override
  _OfflineReaderScreenState createState() => _OfflineReaderScreenState();
}

class _OfflineReaderScreenState extends State<_OfflineReaderScreen> {
  final _pageController = PageController();
  //final _listController = ScrollController();
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  bool isTopVisible;
  bool isBottomVisible;
  int currentPage;
  int numPages;
  ReadingMode mode;
  double brightness;

  @override
  void initState() {
    super.initState();
    isTopVisible = true;
    isBottomVisible = true;
    currentPage = 0;
    numPages = 0;
    mode = prefs.getReadingMode();
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
    return Scaffold(
      body: BlocConsumer<OfflinePagesBloc, OfflinePagesState>(
        listener: (context, state) {
          if (state is LoadedOfflinePages) {
            setState(() {
              numPages = state.list.length;
            });
          }
        },
        builder: (context1, state1) {
          if (state1 is OfflinePagesError) {
            return Center(
              child: ErrorButton(
                onClick: (_) {
                  BlocProvider.of<OfflinePagesBloc>(context)
                      .add(LoadOfflinePages(widget.download));
                },
              ),
            );
          }
          if (state1 is LoadingOfflinePages) {
            return Center(child: AppProgressIndicator.page());
          }
          return SafeArea(
            child: Stack(children: [
              widget.isHorizontal
                  ? PageView(
                      controller: _pageController,
                      children: state1.list
                          .map((image) => _mangaPage(image))
                          .toList(),
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = _pageController.page.round();
                          _hideAll();
                        });
                      },
                    )
                  : NotificationListener<ScrollEndNotification>(
                      onNotification: (_) {
                        setState(() {
                          currentPage = getMin();
                          _hideAll();
                        });
                        return true;
                      },
                      child: ScrollablePositionedList.builder(
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                        itemCount: state1.list.length,
                        itemBuilder: (context, index) {
                          return _mangaPage(state1.list[index]);
                        },
                      ),
                    ),
              Positioned(
                top: 0,
                child: TobBarWidget(
                  isTopVisible: isTopVisible,
                  isOffline: true,
                  slug: widget.download.slug,
                  chapter: widget.download.number,
                  showMenuCallback: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return MenuDialog(
                            isOnline: false,
                            currentPage: currentPage,
                            reloadReader: _reloadReader,
                            showSettingsCallback: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) => SettingsDialog(
                                    mode: mode,
                                    brightness: brightness,
                                    setStateCallback: () {
                                      setState(() {});
                                    },
                                    reloadReader: _reloadReader,
                                    onBrightnessChanged: (value) {
                                      setState(() {
                                        brightness = value;
                                      });
                                      Screen.setBrightness(brightness);
                                    },
                                  ),
                                );
                              });
                            },
                            shareCallback: () {
                              ShareLink().shareChapter(
                                  widget.download.name,
                                  widget.download.slug,
                                  widget.download.number,
                                  context);
                            },
                          );
                        });
                  },
                  showChaptersCallback: () {
                    /*
                    TODO: make sure you want to delete this
                    showDialog(
                      context: context,
                      builder: (context) => ChaptersListDialog(
                        current: widget.chapter,
                        list: state2.mangaDetail.chapters,
                        reloadReader: (chapter) {
                          _reloadReader(chapter: chapter);
                        },
                      ),
                    );
                    */
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: BottomBarWidget(
                  isBottomVisible: isBottomVisible,
                  isOffline: true,
                  numPages: numPages,
                  currentPage: currentPage,
                  goToNextChapter: null,
                  goToNextPage: _goToNextPage,
                  goToPreviousChapter: null,
                  goToPreviousPage: _goToPreviousPage,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _mangaPage(String image) {
    return GestureDetector(
      onTap: () {
        if (isTopVisible || isBottomVisible) {
          setState(() {
            _hideAll();
          });
        } else {
          setState(() {
            isTopVisible = true;
            isBottomVisible = true;
          });
        }
      },
      // handle double click for zooming
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: PhotoView(
          customSize: MediaQuery.of(context).size,
          tightMode: !widget.isHorizontal,
          imageProvider:
              Features.isMockMoor ? AssetImage(image) : FileImage(File(image)),
          loadingBuilder: (context, event) => Container(
            child: Center(
                child: widget.isHorizontal
                    ? AppProgressIndicator()
                    : AppProgressIndicator.custom(
                        size: 400,
                      )),
            color: prefs.isBlackBackground() ? Colors.black : Colors.white,
          ),
          backgroundDecoration: BoxDecoration(
              color: prefs.isBlackBackground() ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  void _goToNextPage() {
    if (widget.isHorizontal) {
      _pageController.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //_listController.animateTo((currentPage + 1).toDouble(),
      //    duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      // TODO: make sure this work well
      _itemScrollController.scrollTo(
        index: getMin() + 1,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  void _goToPreviousPage() {
    if (widget.isHorizontal) {
      _pageController.animateToPage(currentPage - 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //_listController.animateTo((currentPage - 1).toDouble(),
      //    duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      _itemScrollController.scrollTo(
        index: getMin() - 1,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  int getMin() {
    final min = _itemPositionsListener.itemPositions.value
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
            position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;
    return min;
  }

  void _hideAll() {
    isTopVisible = false;
    isBottomVisible = false;
  }

  void _reloadReader({String chapter}) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OfflineReaderScreen(
            download: widget.download,
            isHorizontal: prefs.getReadingMode() == ReadingMode.Horizontal,
          ),
        ),
      );
    });
  }
}
