import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/utils/enums.dart';
import 'package:rxdart/rxdart.dart';
import 'package:manga_scraper/repositories/downloads_list_repo.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/service_locator.dart';

class DownloadsListBloc extends BaseBloc<DownloadsListState> {
  final _repo = serviceLocator.get<DownloadsListRepository>();
  DownloadsListBloc() : super(LoadingDownloadsList([], []));

  StreamSubscription<List<DownloadData>> _downloadsSub;

  @override
  transformEvents(events, transformFn) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 300)), transformFn);
  }

  void pause() {
    _downloadsSub?.pause();
  }

  void resume() {
    _downloadsSub?.resume();
  }
}

class StreamDownloadList
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield LoadingDownloadsList(current.list, current.selections);

    final result = bloc._repo.stream();
    result.listen((data) {
      if (data.isNotEmpty) {
        if (data['status'] == UiDownloadAction.streamingDownloads.toText()) {
          final list = (data['list'] as List)
              .map((e) => DownloadData.fromJson(e))
              .toList();
          bloc.add(UpdateDownloadsList(
              list, List.generate(list.length, (index) => false)));
        }

        if (data['status'] == UiDownloadAction.errorStreaming.toText()) {
          bloc.add(UpdateDownloadsList(null, null));
        }

        if (data['status'] == UiDownloadAction.startedDownload.toText()) {
          bloc.add(AddSingleDownload(DownloadData.fromJson(data['download'])));
        }

        if (data['status'] == UiDownloadAction.progressUpdate.toText()) {
          bloc.add(UpdateSingleDownload(
              data['slug'], data['number'], data['progress']));
        }

        if (data['status'] == UiDownloadAction.downloadFailed.toText()) {
          bloc.add(SingleDownloadFailed(data['slug'], data['number']));
        }

        if (data['status'] == UiDownloadAction.downloadCompleted.toText()) {
          bloc.add(SingleDownloadSuccess(data['slug'], data['number']));
        }

        if (data['status'] == UiDownloadAction.deletedDownload.toText()) {
          print(
              'data from service delete : name of ${data['slug']} and number of ${data['number']}');
          bloc.add(DeleteSingleDownload(data['slug'], data['number']));
        }

        if (data['status'] == UiDownloadAction.deletedDownloads.toText()) {
          final list = (data['list'] as List)
              .map((e) => DownloadData.fromJson(e))
              .toList();
          bloc.add(DeleteDownloadsList(list));
        }

        if (data['status'] == UiDownloadAction.errorDeleting.toText()) {
          bloc.add(DeletionError());
        }
      }
    });
  }
}

class AddSingleDownload
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final DownloadData download;

  AddSingleDownload(this.download);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield LoadedDownloadsList(
        current.list..add(download), current.selections..add(false));
  }
}

class UpdateSingleDownload
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final String slug;
  final String number;
  final int progress;

  UpdateSingleDownload(this.slug, this.number, this.progress);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    final newList = current.list;
    for (int i = 0; i < newList.length; i++) {
      if (newList[i].slug == slug && newList[i].number == number) {
        newList[i] = newList[i].copyWith(progress: progress);
      }
    }
    yield LoadedDownloadsList(newList, current.selections);
  }
}

class DeleteSingleDownload
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final String slug;
  final String number;

  DeleteSingleDownload(this.slug, this.number);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    final newList = current.list;
    final newSelections = current.selections;
    for (int i = 0; i < newList.length; i++) {
      if (newList[i].slug == slug && newList[i].number == number) {
        print(
            'removed index : $i which has name of $slug and number of $number');
        newList.removeAt(i);
        newSelections.removeAt(i);
        break;
      }
    }
    yield LoadedDownloadsList(newList, newSelections);
  }
}

class DeleteDownloadsList
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final List<DownloadData> list;

  DeleteDownloadsList(this.list);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    final newList = current.list;
    for (int i = 0; i < list.length; i++) {
      newList.removeWhere((element) =>
          element.slug == list[i].slug && element.number == list[i].number);
    }
    yield LoadedDownloadsList(
        newList, List.generate(newList.length, (index) => false));
  }
}

class SingleDownloadFailed
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final String slug;
  final String number;

  SingleDownloadFailed(this.slug, this.number);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    final newList = current.list;
    for (int i = 0; i < newList.length; i++) {
      if (newList[i].slug == slug && newList[i].number == number) {
        newList[i] = newList[i].copyWith(hasFailed: true);
      }
    }
    yield LoadedDownloadsList(newList, current.selections);
  }
}

class SingleDownloadSuccess
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final String slug;
  final String number;

  SingleDownloadSuccess(this.slug, this.number);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    final newList = current.list;
    for (int i = 0; i < newList.length; i++) {
      if (newList[i].slug == slug && newList[i].number == number) {
        newList[i] =
            newList[i].copyWith(hasFailed: false, isDownloading: false);
      }
    }
    yield LoadedDownloadsList(newList, current.selections);
  }
}

class UpdateDownloadsList
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final List<DownloadData> list;
  final List<bool> selections;

  UpdateDownloadsList(this.list, this.selections);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield list == null
        ? DownloadsListError(null, null, DownloadsError.loadingError)
        : LoadedDownloadsList(list, selections);
  }
}

class UpdateSelection extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final int index;
  final bool newSelection;

  UpdateSelection(this.index, this.newSelection);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    current.selections[index] = newSelection;
    yield LoadedDownloadsList(current.list, current.selections);
  }
}

class UpdateListSelection
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final bool newSelection;

  UpdateListSelection(this.newSelection);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield LoadedDownloadsList(current.list,
        List.generate(current.list.length, (index) => newSelection));
  }
}

class DeleteSelectedList
    extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield DeletingDownloads(current.list, current.selections);

    final toDelete = <DownloadData>[];
    for (int i = 0; i < current.list.length; i++) {
      if (current.selections[i]) toDelete.add(current.list[i]);
    }

    FlutterBackgroundService().sendData({
      'action': ServiceDownloadAction.deleteDownloads.toText(),
      'list': toDelete.map((e) => e.toJson()).toList(),
    });

    /*
    final result = await bloc._repo.deleteList(toDelete);

    if (result.isError) {
      yield DownloadsListError(current.list, current.selections);
    }*/
  }
}

class DeleteSelected extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  final int index;

  DeleteSelected(this.index);
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield DeletingDownloads(current.list, current.selections);

    FlutterBackgroundService().sendData({
      'action': ServiceDownloadAction.deleteDownload.toText(),
      'download': current.list[index].toJson(),
    });
  }
}

class DeletionError extends BlocEvent<DownloadsListBloc, DownloadsListState> {
  @override
  Stream<DownloadsListState> toState(
      DownloadsListBloc bloc, DownloadsListState current) async* {
    yield DownloadsListError(
        current.list, current.selections, DownloadsError.deletingError);
  }
}

abstract class DownloadsListState {
  final List<DownloadData> list;
  final List<bool> selections;

  DownloadsListState(this.list, this.selections);

  isAllSelected() {
    return selections.where((element) => !element).isEmpty;
  }
}

enum DownloadsError {
  loadingError,
  deletingError,
}

class DownloadsListError extends DownloadsListState {
  final DownloadsError error;
  DownloadsListError(List<DownloadData> list, List<bool> selections, this.error)
      : super(list, selections);
}

class LoadingDownloadsList extends DownloadsListState {
  LoadingDownloadsList(List<DownloadData> list, List<bool> selections)
      : super(list, selections);
}

class DeletingDownloads extends DownloadsListState {
  DeletingDownloads(List<DownloadData> list, List<bool> selections)
      : super(list, selections);
}

class LoadedDownloadsList extends DownloadsListState {
  LoadedDownloadsList(List<DownloadData> list, List<bool> selections)
      : super(list, selections);
}
