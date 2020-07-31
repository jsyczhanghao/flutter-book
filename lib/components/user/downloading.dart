import 'package:flutter/material.dart';
import '../../tasks/download/download.dart';

class UserDownloadingBook extends StatefulWidget {
  final Downloader downloader;
  final Widget child;

  UserDownloadingBook({Key key, this.downloader, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserDownloadingBookState();
  }
}

class UserDownloadingBookState extends State<UserDownloadingBook> {
  DownloaderStatus _status = DownloaderStatus.PAUSED;
  double _progress;

  @override
  void initState() {
    super.initState();
    widget.downloader.on(DownloaderEvent.PROGRESS, _update);
    _setState();
  }

  @override
  void didUpdateWidget(UserDownloadingBook oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.downloader.off(DownloaderEvent.PROGRESS, _update);
    widget.downloader.on(DownloaderEvent.PROGRESS, _update);
    _update(null);
  }

  _update(double progress) {
    setState(() {
      _setState();
    });
  }

  _setState() {
    _progress = widget.downloader.book.progress;
    _status = widget.downloader.status;
  }

  @override
  void dispose() {
    widget.downloader.off(DownloaderEvent.PROGRESS, _update);
    super.dispose();
  }

  onClickIconButton() {
    DownloadManager.getInstance().start(widget.downloader);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Positioned(
          child: Container(
            width: MediaQuery.of(context).size.width * (_progress ?? 0),
            height: 120,
            color: Colors.blue.withOpacity(0.3),
          ),
        ),
        Positioned(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              child: IconButton(
                alignment: Alignment.center,
                splashColor: Colors.black,
                color: Colors.black,
                icon: Icon(
                  _status == DownloaderStatus.PAUSED
                      ? Icons.play_arrow
                      : Icons.pause,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () => onClickIconButton(),
              ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Text(
            widget.downloader.status == DownloaderStatus.ING
                ? (_progress == null
                    ? '计算中'
                    : '已下载 ${(_progress * 100).toStringAsFixed(2)}%')
                : (_status == DownloaderStatus.RETRYING ? '网络出错重试中..' : '等待下载'),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
