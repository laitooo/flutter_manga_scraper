import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/blocs/downloads_list_bloc.dart';
import 'package:manga_scraper/screens/details/manga_details_screen.dart';
import 'package:manga_scraper/screens/reader/offline_reader_screen.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:manga_scraper/utils/preferences.dart';
import 'package:manga_scraper/utils/extensions.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/download_view.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';

class DownloadsScreen extends StatelessWidget {
  final Key globalKey;

  const DownloadsScreen({Key key, this.globalKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloadsListBloc()..add(StreamDownloadList()),
      child: _DownloadsScreen(
        key: globalKey,
      ),
    );
  }
}

class _DownloadsScreen extends StatefulWidget {
  const _DownloadsScreen({Key key}) : super(key: key);
  @override
  DownloadsScreenState createState() => DownloadsScreenState();
}

class DownloadsScreenState extends State<_DownloadsScreen> {
  void deleteSelected() {
    BlocProvider.of<DownloadsListBloc>(context).add(DeleteSelectedList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DownloadsListBloc, DownloadsListState>(
          listener: (context, state) {
        if (state is DownloadsListError &&
            state.error == DownloadsError.deletingError) {
          context.showSnackBar(
            Language.of(context).errorDeletingChapters,
            2,
          );
        }
      }, builder: (context, state) {
        if (state is LoadingDownloadsList) {
          return Center(child: AppProgressIndicator.page());
        } else if (state is DownloadsListError &&
            state.error == DownloadsError.loadingError) {
          return Center(child: ErrorButton(
            onClick: (_) {
              BlocProvider.of<DownloadsListBloc>(context)
                  .add(StreamDownloadList());
            },
          ));
        } else {
          return ListView(
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: state.isAllSelected() && state.list.isNotEmpty,
                        onChanged: (isChecked) {
                          BlocProvider.of<DownloadsListBloc>(context)
                              .add(UpdateListSelection(isChecked));
                        }),
                    Text(
                      Language.of(context).downloadedChapters +
                          ' (${state.list.length})',
                      style: TextStyle(
                        color: AppColors.getPrimaryColor(),
                      ),
                      strutStyle: AppFonts.getStyle(),
                    ),
                    Container(
                      width: 50,
                    ),
                  ],
                ),
              ),
              ...List.generate(
                state.list.length,
                (index) => DownloadView(
                  download: state.list[index],
                  isSelected: state.selections[index],
                  onCheckChange: (isSelected) {
                    BlocProvider.of<DownloadsListBloc>(context)
                        .add(UpdateSelection(index, isSelected));
                  },
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MangaDetailsScreen(
                          slug: state.list[index].slug,
                          name: state.list[index].name,
                        ),
                      ),
                    );
                  },
                  onChapterClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfflineReaderScreen(
                          download: state.list[index],
                          isHorizontal:
                              prefs.getReadingMode() == ReadingMode.Horizontal,
                        ),
                      ),
                    );
                  },
                  onDeleteClick: () {
                    BlocProvider.of<DownloadsListBloc>(context)
                        .add(DeleteSelected(index));
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
