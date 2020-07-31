import 'dart:async';
import '../../libs/libs.dart';
import '../../api/api.dart';

enum DownloaderStatus {
  ING,
  PAUSED,
  RETRYING,
  FAILED,
  COMPLETED,
}

enum DownloaderEvent {
  PROGRESS,
  RETRY,
  START,
  CANCEL,
  COMPLETE,
}

class Downloader extends Listener {
  final BookModel book;
  List<BookChapterModel> chapters;
  Timer timer;
  DownloaderStatus status = DownloaderStatus.PAUSED;
  BookApi api;
  int downloaded = 0;
  int total = 0;

  Downloader({this.book}) {
    api = BookApiFactory.create(book.id, book.type);
  }

  Future<void> start() async {
    if (status == DownloaderStatus.ING || status == DownloaderStatus.RETRYING)
      return;

    total = await api.getChaptersCount();
    int waits = await api.getChaptersCount(onlyUnCached: true);
    downloaded = total - waits;
    book.progress = downloaded / total;
    status = DownloaderStatus.ING;
    fire(DownloaderEvent.START);
    _download();
  }

  _download() {
    timer = Timer(Duration(seconds: 1), () async {
      List<BookChapterModel> chapters =
          await api.chapters(limit: 1, onlyUnCached: true);

      if (chapters.length == 0) {
        await api.saveStatus(BookStatus.DOWNLOADED);
        timer = null;
        status = DownloaderStatus.COMPLETED;
        fire(DownloaderEvent.COMPLETE);
        return;
      }

      BookChapterModel chapter = chapters.first;
      BookChapterApi chapterApi = BookChapterApiFactory.create(
          chapter.bookid, chapter.type, chapter.id);
      String content = await chapterApi.download(chapter.url);

      if (status == DownloaderStatus.PAUSED) {
        return;
      }

      if (content != null) {
        book.progress = (++downloaded / total);
        status = DownloaderStatus.ING;
        await _download();
      } else {
        status = DownloaderStatus.RETRYING;
        fire(DownloaderEvent.RETRY);
        timer = Timer(Duration(seconds: 5), () => _download());
      }

      fire(DownloaderEvent.PROGRESS, book.progress);
    });
  }

  void cancel() {
    if (status == DownloaderStatus.PAUSED ||
        status == DownloaderStatus.COMPLETED) return;

    status = DownloaderStatus.PAUSED;

    try {
      timer.cancel();
    } catch (e) {}

    fire(DownloaderEvent.CANCEL);
  }
}
