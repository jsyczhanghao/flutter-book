import 'package:flutter/widgets.dart';
import '../../tasks/download/download.dart';
import '../../models/models.dart';
import './books.dart';
import './downloading.dart';

class UserDownloadingBooks extends UserBooks {
  UserDownloadingBooks({Key key, Function onClickEmptyButton}) : super(key: key, onClickEmptyButton: onClickEmptyButton);

  @override
  State<StatefulWidget> createState() {
    return UserDownloadingBooksState();
  }
}

class UserDownloadingBooksState extends UserBooksState {
  List<Downloader> _downloaders = [];

  @override
  void initState() {
    super.initState();
    DownloadManager.getInstance().on(DownloaderManagerEvent.LIST_UPDATE, load);
  }

  @override
  load() {
    _downloaders = DownloadManager.getInstance().downloaders;
    books = _downloaders.map((Downloader downloader) {
      return downloader.book;
    }).toList();
    
    setState(() {});
  }

  @override
  void dispose() {
    DownloadManager.getInstance().off(DownloaderManagerEvent.LIST_UPDATE, load);
    super.dispose();
  }

  @override
  Widget renderItem(Widget child, int index) {
    return UserDownloadingBook(
      downloader: _downloaders[index],
      child: child,
    );
  }

  @override
  onDismissed(BookModel book, int index) {
    DownloadManager.getInstance().remove(_downloaders[index]);
  }
}