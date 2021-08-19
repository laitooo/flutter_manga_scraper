import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/widgets/buttons.dart';
import 'package:manga_scraper/widgets/progress_indicator.dart';

class PaginatedList<
    ListBloc extends Bloc<dynamic, ListState>,
    ListState,
    ListLoading extends ListState,
    ListEnd extends ListState,
    ListError extends ListState> extends StatefulWidget {
  const PaginatedList({
    Key key,
    @required this.header,
    @required this.emptyText,
    @required this.onLoadMore,
    this.onRetry,
    @required this.getItemsCount,
    @required this.buildItemWidget,
    @required this.onError,
  }) : super(key: key);

  final Widget header;
  final String emptyText;
  final void Function(BuildContext context) onLoadMore;
  final void Function(BuildContext context) onRetry;
  final int Function(ListState state) getItemsCount;
  final Widget Function(ListState state, int index) buildItemWidget;
  final void Function(ListError state) onError;

  bool canLoadMoreByScrolling(ListState state) {
    return state is! ListLoading && state is! ListEnd && state is! ListError;
  }

  @override
  _PaginatedListState<ListBloc, ListState, ListLoading, ListEnd, ListError>
      createState() => _PaginatedListState<ListBloc, ListState, ListLoading,
          ListEnd, ListError>();
}

class _PaginatedListState<
        ListBloc extends Bloc<dynamic, ListState>,
        ListState,
        ListLoading extends ListState,
        ListEnd extends ListState,
        ListError extends ListState>
    extends State<
        PaginatedList<ListBloc, ListState, ListLoading, ListEnd, ListError>> {
  final ScrollController controller = ScrollController();

  PaginatedList<ListBloc, ListState, ListLoading, ListEnd, ListError>
      get listWidget {
    return widget;
  }

  bool isEmpty;

  @override
  void initState() {
    super.initState();
    isEmpty = true;
    controller.addListener(() {
      if (_shouldLoadMore()) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        // controller's listener is called only when the scolling changes. This creates a problem if the loaded page
        // is smaller than screen size, since the listener will not be called and hence next page won't be loaded.
        // To solve this, we add a listener to the list bloc state that is the same as scoll controller's listener.
        if (_shouldLoadMore()) {
          _loadMore();
        }
        if (state is ListError) {
          listWidget.onError(state);
        }
      },
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          final length = listWidget.getItemsCount(state);
          if (state is ListError && length == 0) {
            isEmpty = true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: ErrorButton(
                  onClick: listWidget.onRetry ?? listWidget.onLoadMore,
                ),
              ),
            );
          }

          if (state is ListLoading && length == 0) {
            isEmpty = true;
            return Center(child: AppProgressIndicator());
          }

          isEmpty = false;
          return ListView.builder(
            controller: controller,
            itemCount: length + 2,
            itemBuilder: (context, i) {
              final isHeader = i == 0;
              final isProgressIndicator = i == length + 1;

              if (isHeader) {
                return listWidget.header;
              }

              if (isProgressIndicator) {
                if (state is ListEnd) {
                  final endText = Language.of(context).endOfList;
                  final text = length == 0 ? widget.emptyText ?? endText : " ";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                    ),
                  );
                } else if (state is ListError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: ErrorButton(
                        onClick: listWidget.onRetry ?? listWidget.onLoadMore,
                      ),
                    ),
                  );
                } else {
                  return Center(child: AppProgressIndicator());
                }
              }

              return listWidget.buildItemWidget(state, i - 1);
            },
          );
        },
      ),
    );
  }

  bool _shouldLoadMore() {
    if (!isEmpty) {
      if (controller.position.extentAfter <
          controller.position.extentInside ~/ 8) {
        final state = BlocProvider.of<ListBloc>(context).state;
        if (listWidget.canLoadMoreByScrolling(state)) {
          return true;
        }
      }
    }
    return false;
  }

  void _loadMore() {
    listWidget.onLoadMore(context);
  }
}

class PaginatedGridView<
    ListBloc extends Bloc<dynamic, ListState>,
    ListState,
    ListLoading extends ListState,
    ListEnd extends ListState,
    ListError extends ListState> extends StatefulWidget {
  const PaginatedGridView({
    Key key,
    @required this.header,
    @required this.emptyText,
    @required this.onLoadMore,
    this.onRetry,
    @required this.getItemsCount,
    @required this.buildItemWidget,
    this.childAspectRatio,
    this.crossAxisCount,
    @required this.onError,
  }) : super(key: key);

  final Widget header;
  final String emptyText;
  final void Function(BuildContext context) onLoadMore;
  final void Function(BuildContext context) onRetry;
  final int Function(ListState state) getItemsCount;
  final Widget Function(ListState state, int index) buildItemWidget;
  final Function(ListError state) onError;
  final double childAspectRatio;
  final int crossAxisCount;

  bool canLoadMoreByScrolling(ListState state) {
    return state is! ListLoading && state is! ListEnd && state is! ListError;
  }

  @override
  _PaginatedGridViewState<ListBloc, ListState, ListLoading, ListEnd, ListError>
      createState() => _PaginatedGridViewState<ListBloc, ListState, ListLoading,
          ListEnd, ListError>();
}

class _PaginatedGridViewState<
        ListBloc extends Bloc<dynamic, ListState>,
        ListState,
        ListLoading extends ListState,
        ListEnd extends ListState,
        ListError extends ListState>
    extends State<
        PaginatedGridView<ListBloc, ListState, ListLoading, ListEnd,
            ListError>> {
  final ScrollController controller = ScrollController();

  PaginatedGridView<ListBloc, ListState, ListLoading, ListEnd, ListError>
      get listWidget {
    return widget;
  }

  bool isEmpty;

  @override
  void initState() {
    super.initState();
    isEmpty = true;
    controller.addListener(() {
      if (_shouldLoadMore()) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        // controller's listener is called only when the scolling changes. This creates a problem if the loaded page
        // is smaller than screen size, since the listener will not be called and hence next page won't be loaded.
        // To solve this, we add a listener to the list bloc state that is the same as scoll controller's listener.
        if (_shouldLoadMore()) {
          _loadMore();
        }

        if (state is ListError) {
          widget.onError(state);
        }
      },
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          final endText = Language.of(context).endOfList;
          final length = listWidget.getItemsCount(state);

          if (state is ListError && length == 0) {
            isEmpty = true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: ErrorButton(
                  onClick: listWidget.onRetry ?? listWidget.onLoadMore,
                ),
              ),
            );
          }

          if (state is ListLoading && length == 0) {
            isEmpty = true;
            return Center(child: AppProgressIndicator());
          }

          isEmpty = false;
          return SingleChildScrollView(
            controller: controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                listWidget.header,
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: widget.crossAxisCount,
                  scrollDirection: Axis.vertical,
                  childAspectRatio: widget.childAspectRatio,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < length; i++)
                      listWidget.buildItemWidget(state, i)
                  ],
                ),
                if (state is ListEnd)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        length == 0 ? widget.emptyText ?? endText : " ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        strutStyle: AppFonts.getStyle(),
                      ),
                    ),
                  )
                else if (state is ListError)
                  ErrorButton(
                    onClick: listWidget.onRetry ?? listWidget.onLoadMore,
                  )
                else
                  Center(child: AppProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _shouldLoadMore() {
    if (!isEmpty) {
      if (controller.position.extentAfter <
          controller.position.extentInside ~/ 8) {
        final state = BlocProvider.of<ListBloc>(context).state;
        if (listWidget.canLoadMoreByScrolling(state)) {
          return true;
        }
      }
    }
    return false;
  }

  void _loadMore() {
    listWidget.onLoadMore(context);
  }
}
