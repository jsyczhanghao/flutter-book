import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../../models/models.dart';
import '../../tasks/tts/tts.dart';
import '../../libs/libs.dart';

class TtsPlayer extends StatefulWidget {
  final BookModel book;
  final int chapter;
  final bool iftts;

  TtsPlayer({
    Key key,
    this.book,
    this.chapter,
    this.iftts,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TtsPlayerState();
  }
}

class TtsPlayerState extends State<TtsPlayer> with WidgetsBindingObserver {
  bool _isPaused = true;
  String _title;
  double _seek = 0;
  bool isChangingProgress = false;
  int chapter;
  TtsStorage storage;
  StreamSubscription listener;
  static const double ICON_SIZE = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
    start();
  }

  switchPlayOrStop() {
    if (storage == null) return;

    switch (storage.status) {
      case TtsStorageStatus.PLAYING:
        pause();
        break;

      case TtsStorageStatus.PAUSED:
        resume();
        break;

      case TtsStorageStatus.STOPED:
      case TtsStorageStatus.READY:
        speak();
        break;

      default:
        break;
    }
  }

  _loadStorage([bool _setState = true]) async {
    storage = await TtsStorage.get();

    if (storage == null) return;

    setState(() {
      chapter = storage.model.id;
      _title = storage.model.title;
      _isPaused = storage.status != TtsStorageStatus.PLAYING;
    });
  }

  start() async {
    await _loadStorage();

    if (storage != null) {
      if (widget.chapter == null) {
        return ;
      } else if (storage.model.id == widget.chapter && storage.model.book.id == widget.book.id) {
        return ;
      } else {
        chapter = widget.chapter;
      }
    } else {
      chapter = widget.chapter;
    }

    speak();
  }

  speak([int id]) async {
    await TtsController.speak(BookChapterModel(
      id: id == null ? chapter : id,
      book: widget.book,
    ));
  }

  resume() {
    TtsController.resume();
  }

  pause() {
    TtsController.pause();
  }

  seek(double i, bool unSeek) {
    setState(() {
      _seek = i;
    });

    if (unSeek) {
      TtsController.seek(i.toInt());
      isChangingProgress = false;
    }
  }

  skip2next() {
    if (TtsController.tasking) {
      TtsController.skip2next();
    } else {
      speak(chapter + 1);
    }
  }

  skip2previous() {
    if (TtsController.tasking) {
      TtsController.skip2previous();
    } else {
      speak(chapter - 1);
    }
  }

  @override
  void didUpdateWidget(TtsPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.chapter != oldWidget.chapter) {
      start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              widget.book.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Image(
              height: 250,
              fit: BoxFit.cover,
              image: Helper.image(widget.book.img),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              _title == null ? '加载中。。。' : _title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Slider(
              min: 0,
              max: 100,
              divisions: 100,
              value: _seek,
              onChangeEnd: (double i) => seek(i, true),
              onChanged: (double i) => seek(i, false),
              onChangeStart: (double i) {
                isChangingProgress = true;
              },
            ),
          ),
          Container(
            width: 250,
            margin: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: ICON_SIZE,
                  icon: Icon(Icons.skip_previous),
                  onPressed: skip2previous,
                ),
                FlatButton(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.blue,
                    ),
                    height: 60,
                    width: 60,
                    child: Icon(_isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white, size: ICON_SIZE),
                  ),
                  onPressed: switchPlayOrStop,
                ),
                IconButton(
                  iconSize: ICON_SIZE,
                  icon: Icon(Icons.skip_next),
                  onPressed: skip2next,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await disconnect();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _loadStorage();
        await connect();
        break;
      case AppLifecycleState.paused:
        await disconnect();
        break;
      default:
        break;
    }
  }

  connect() {
    AudioService.connect();
    listen();
  }

  disconnect() async {
    await AudioService.disconnect();

    if (listener != null) {
      await listener.cancel();
      listener = null;
    }
  }

  listen() {
    listener =
        AudioService.playbackStateStream.listen((PlaybackState state) async {
      if (state == null) return;

      switch (state.basicState) {
        case BasicPlaybackState.connecting:
          _loadStorage();
          seek(0, false);
          return;

        case BasicPlaybackState.playing:
          if (isChangingProgress) return;
          seek(state.position.toDouble(), false);
          break;

        default:
          break;
      }

      _loadStorage();
    });
  }
}
