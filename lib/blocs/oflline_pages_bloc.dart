import 'package:manga_scraper/models/download.dart';
import 'package:manga_scraper/utils/base_bloc.dart';
import 'package:manga_scraper/utils/features.dart';
import 'package:manga_scraper/utils/generator.dart';
import 'package:path_provider/path_provider.dart';

class OfflinePagesBloc extends BaseBloc<OfflinePagesState> {
  OfflinePagesBloc() : super(LoadingOfflinePages([]));
}

class LoadOfflinePages extends BlocEvent<OfflinePagesBloc, OfflinePagesState> {
  final DownloadData download;

  LoadOfflinePages(this.download);
  @override
  Stream<OfflinePagesState> toState(
      OfflinePagesBloc bloc, OfflinePagesState current) async* {
    yield LoadingOfflinePages(current.list);

    if (Features.isMockMoor) {
      final list = List.generate(
        generator.generateNumber(50),
        (index) => generator.mangaAsset(),
      );
      yield LoadedOfflinePages(list);
    } else {
      final extPath = (await getExternalStorageDirectory()).path;
      final path = "$extPath/Manga Online2/downloads/${download.name}/" +
          download.number;

      final list = List.generate(download.images,
          (index) => path + '/image${index + 1}.${download.extension}');
      yield LoadedOfflinePages(list);
    }
  }
}

abstract class OfflinePagesState {
  final List<String> list;

  OfflinePagesState(this.list);
}

class LoadingOfflinePages extends OfflinePagesState {
  LoadingOfflinePages(List<String> list) : super(list);
}

class OfflinePagesError extends OfflinePagesState {
  OfflinePagesError(List<String> list) : super(list);
}

class LoadedOfflinePages extends OfflinePagesState {
  LoadedOfflinePages(List<String> list) : super(list);
}
