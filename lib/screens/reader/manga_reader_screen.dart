import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/manga_details_bloc.dart';
import 'package:manga_scraper/blocs/manga_pages_bloc.dart';
import 'package:manga_scraper/screens/reader/chapters_list_dialog.dart';
import 'package:manga_scraper/screens/reader/menu_dialog.dart';
import 'package:manga_scraper/screens/reader/reader_widgets.dart';
import 'package:manga_scraper/screens/reader/settings_dialog.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/utils/share.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screen/screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MangaReaderScreen extends StatelessWidget {
  final String name;
  final String slug;
  final String chapter;
  final String volume;
  final bool isHorizontal;

  const MangaReaderScreen(
      {Key key,
      @required this.name,
      @required this.slug,
      @required this.chapter,
      @required this.volume,
      @required this.isHorizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  MangaPagesBloc()..add(LoadMangaPages(slug, chapter, volume))),
          BlocProvider(
              create: (_) => MangaDetailsBloc()..add(LoadMangaDetails(slug))),
        ],
        child: _MangaReaderScreen(
          name: name,
          slug: slug,
          chapter: chapter,
          isHorizontal: isHorizontal,
        ));
  }
}

class _MangaReaderScreen extends StatefulWidget {
  final String name;
  final String slug;
  final String chapter;
  final String volume;
  final bool isHorizontal;

  const _MangaReaderScreen(
      {Key key,
      this.name,
      this.slug,
      this.volume,
      this.chapter,
      this.isHorizontal})
      : super(key: key);

  @override
  _MangaReaderScreenState createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends State<_MangaReaderScreen> {
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
      body: BlocConsumer<MangaPagesBloc, MangaPagesState>(
        listener: (context, state) {
          if (state is LoadedMangaPages) {
            setState(() {
              numPages = state.list.length;
            });
          }
          if (state is MangaPagesError) {
            context.showSnackBar(
              errorTypeToText(context, state.errorType),
              1,
            );
          }
        },
        builder: (context1, state1) {
          if (state1 is MangaPagesError) {
            return Center(
              child: ErrorButton(
                onClick: (_) {
                  BlocProvider.of<MangaPagesBloc>(context).add(LoadMangaPages(
                      widget.slug, widget.chapter, widget.volume));
                },
              ),
            );
          }
          if (state1 is LoadingMangaPages) {
            return Center(child: AppProgressIndicator.page());
          }
          return BlocConsumer<MangaDetailsBloc, MangaDetailsState>(
              listener: (context2, state2) {
            if (state2 is MangaDetailsError) {
              context.showSnackBar(
                errorTypeToText(context, state2.errorType),
                1,
              );
            }
          }, builder: (context2, state2) {
            if (state2 is MangaDetailsError) {
              return Center(
                child: ErrorButton(
                  onClick: (_) {
                    BlocProvider.of<MangaDetailsBloc>(context)
                        .add(LoadMangaDetails(
                      widget.slug,
                    ));
                  },
                ),
              );
            }
            if (state2 is LoadingMangaDetails) {
              return Center(child: AppProgressIndicator.page());
            }
            return SafeArea(
              child: Stack(children: [
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (_) {
                    if (widget.isHorizontal) {
                      if (_pageController.position.userScrollDirection ==
                          ScrollDirection.reverse) {
                        _goToNextChapter();
                      } else {
                        _goToPreviousChapter();
                      }
                    } else {
                      // TODO: detect vertical over scroll
                      /*if (_listController.position.userScrollDirection ==
                          ScrollDirection.reverse) {
                        _goToNextChapter();
                      } else {
                        _goToPreviousChapter();
                      }*/
                    }
                    return true;
                  },
                  child: widget.isHorizontal
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
                ),
                Positioned(
                  top: 0,
                  child: TobBarWidget(
                    isTopVisible: isTopVisible,
                    isOffline: false,
                    slug: widget.slug,
                    chapter: widget.chapter,
                    showMenuCallback: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MenuDialog(
                              isOnline: true,
                              currentPage: currentPage,
                              reloadReader: _reloadReader,
                              showSettingsCallback: () {
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
                              },
                              shareCallback: () {
                                ShareLink().shareChapter(
                                    widget.name,
                                    widget.slug,
                                    widget.chapter,
                                    widget.volume,
                                    context);
                              },
                            );
                          });
                    },
                    showChaptersCallback: () {
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
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: BottomBarWidget(
                    isBottomVisible: isBottomVisible,
                    isOffline: false,
                    numPages: numPages,
                    currentPage: currentPage,
                    goToNextChapter: _goToNextChapter,
                    goToNextPage: _goToNextPage,
                    goToPreviousChapter: _goToPreviousChapter,
                    goToPreviousPage: _goToPreviousPage,
                  ),
                ),
              ]),
            );
          });
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
              Features.isMockHttp ? AssetImage(image) : NetworkImage(image),
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
    if (currentPage == numPages - 1) {
      _goToNextChapter();
    } else {
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
  }

  void _goToPreviousPage() {
    if (currentPage == 0) {
      _goToPreviousChapter();
    } else {
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
  }

  int getMin() {
    final min = _itemPositionsListener.itemPositions.value
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
            position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;
    return min;
  }

  void _goToNextChapter() {
    final chapters =
        BlocProvider.of<MangaDetailsBloc>(context).state.mangaDetail.chapters;
    int id = 0;
    for (int i = 0; i < chapters.length; i++) {
      if (widget.chapter == chapters[i].number) {
        id = i;
      }
    }
    if (id == chapters.length - 1) {
      context.showSnackBar(
        Language.of(context).thisIsTheLastChapter,
        1,
      );
    } else {
      _reloadReader(chapter: chapters[id + 1].number);
    }
  }

  void _goToPreviousChapter() {
    final chapters =
        BlocProvider.of<MangaDetailsBloc>(context).state.mangaDetail.chapters;
    int id = 0;
    for (int i = 0; i < chapters.length; i++) {
      if (widget.chapter == chapters[i].number) {
        id = i;
      }
    }
    if (id == 0) {
      context.showSnackBar(
        Language.of(context).thisIsTheFirstChapter,
        1,
      );
    } else {
      _reloadReader(chapter: chapters[id - 1].number);
    }
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
          builder: (context) => MangaReaderScreen(
            name: widget.name,
            slug: widget.slug,
            volume: widget.volume,
            chapter: chapter ?? widget.chapter,
            isHorizontal: prefs.getReadingMode() == ReadingMode.Horizontal,
          ),
        ),
      );
    });
  }
}
