import 'dart:async';
import '../../libs/libs.dart';
import '../../api/api.dart';
import './downloader.dart';

enum DownloaderManagerEvent {
  LIST_UPDATE,
  SOME_COMPLETE,
}

class DownloadManager extends Listener {
  List<Downloader> downloaders = List();
  List<Downloader> downloadings = List();
  static DownloadManager instance;
  static const MAX_DOWNLOAD_COUNT = 3;

  DownloadManager() {
    Future(() async {
      List<BookModel> books =
          await BookApi.list(status: BookStatus.DOWNLOADING);
      downloaders = books.map((BookModel book) {
        return _downloader(book);
      }).toList();
      startAll();
    });
  }

  DownloadManager.init() {
    if (instance == null) {
      instance = DownloadManager();
    }
  }

  static DownloadManager getInstance() {
    return instance;
  }

  Future<void> add(BookModel book) async {
    BookApi api = BookApiFactory.create(book.id, book.type);
    await api.try2syncChapters();
    await api.saveStatus(BookStatus.DOWNLOADING);
    Downloader downloader = _downloader(book);
    downloaders.insert(0, downloader);
    await start(downloader, false);
  }

  Downloader _downloader(BookModel book) {
    Downloader downloader = Downloader(book: book);
    downloader.on(DownloaderEvent.COMPLETE, () async {
      remove(downloader);
    });
    return downloader;
  }

  Future<void> start(Downloader downloader, [bool priority = true]) async {
    if (downloader.status == DownloaderStatus.ING ||
        downloader.status == DownloaderStatus.RETRYING) {
      return;
    }

    do {
      if (downloadings.length == MAX_DOWNLOAD_COUNT) {
        if (priority) {
          downloadings.last.cancel();
          downloadings.removeLast();
        } else {
          break;
        }
      } 

      downloadings.insert(0, downloader);
      downloaders.remove(downloader);
      downloaders.insert(0, downloader);
      await downloader.start();
      fire(DownloaderManagerEvent.LIST_UPDATE);
    } while (false);
  }

  remove(Downloader downloader) async {
    downloaders.remove(downloader);
    downloadings.remove(downloader);
    
    if (downloader.status != DownloaderStatus.PAUSED) {
      downloader.cancel();
      
      for (Downloader next in downloaders) {
        if (next.status == DownloaderStatus.PAUSED) {
          downloadings.add(next);
          await next.start();
          break;
        }
      }
    }

    fire(DownloaderManagerEvent.LIST_UPDATE);
  }

  startAll() async {
    for (Downloader downloader in downloaders) {
      if (downloadings.length < MAX_DOWNLOAD_COUNT) {
        downloadings.add(downloader);
        await downloader.start();
      } else {
        downloader.cancel();
      }
    }

    fire(DownloaderManagerEvent.LIST_UPDATE);
  }
}
