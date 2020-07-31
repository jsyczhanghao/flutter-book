import 'package:flutter/material.dart';
import 'dart:convert';
import '../../api/api.dart';
import '../../libs/libs.dart';
import '../../components/common/reader/reader.dart';
import '../../components/tts/iftts.dart';

class ReadView extends StatefulWidget {
  final BookModel book;
  bool iftts;

  ReadView({Key key, this.book, this.iftts = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReadViewState();
  }
}

class ReadViewState extends State<ReadView> {
  String _content;
  int _total;
  int _index = 0;
  int _page = 0;
  String _title;
  ReaderSupportConfigs _configs = ReaderSupportConfigs();
  bool loading = false;
  BookApi bookApi;

  @override
  initState() {
    super.initState();
    _ready();
  }

  _ready() async {
    String configs = Storage.get('book');

    if (configs != null) {
      Map cfgs = jsonDecode(configs);

      _configs = ReaderSupportConfigs(
        fontFamily: cfgs['fontFamily'],
        fontSize: cfgs['fontSize'],
        theme: cfgs['theme'],
      );
    }

    bookApi = BookApiFactory.create(widget.book.id, widget.book.type);

    Map info = await bookApi.getProgress();

    if (info != null) {
      _index = info['chapter'];
      _page = info['page'];
    }

    load(_index, false, true);
  }

  load(int index, bool byProgress, [bool isInit]) {
    if (loading == true) return false;

    loading = true;
    BookChapterApi chapterApi =
        BookChapterApiFactory.create(widget.book.id, widget.book.type, index);

    Future.wait([chapterApi.modelWithContent(), bookApi.getChaptersCount()])
        .then((res) {
      if (res[0] == null) {
        Toast.show(context, title: '网络出错啦~', duration: 1);
        return;
      }

      if (index < _index && !byProgress) {
        _page = 100000;
      } else if (isInit != true) {
        _page = 0;
      }

      BookChapterModel chapter = res[0];

      _content = chapter.content;
      _title = chapter.title;
      _total = res[1];
      _index = index;

      setState(() {});
      print('fdjkffds');
      bookApi.saveProgress(_index, _page);
      BookChapterApiFactory.create(widget.book.id, widget.book.type, index - 1)
          .download();
      BookChapterApiFactory.create(widget.book.id, widget.book.type, index + 1)
          .download();
    }).whenComplete(() {
      loading = false;
    });
  }

  go2chapters() {
    Navigator.pushNamed(context, '/book/chapters', arguments: widget.book)
        .then((chapter) {
      if (chapter != null) {
        load(chapter, true);
      }
    });
  }

  go2tts() {
    if (widget.iftts) {
      Navigator.of(context).pop(_index);
    } else {
      Navigator.pushNamed(context, '/book/tts', arguments: widget.book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Reader(
            page: _page,
            title: _title,
            text: _content,
            configs: ReaderSupportConfigs.from(
              _configs,
              index: _index,
              total: _total,
              actions: <ReaderSupportAction>[
                ReaderSupportAction(
                  icon: Icon(Icons.menu),
                  onPressed: () => go2chapters(),
                ),
                ReaderSupportAction(
                  icon: Icon(Icons.music_note),
                  onPressed: () => go2tts(),
                ),
              ],
            ),
            onSwitchChapter: (int i, bool byProgress) {
              load(_index + i, byProgress);
            },
            onSwitchPage: (int page) {
              if (page == _page) {
                return null;
              }
              _page = page;
              bookApi.saveProgress(_index, page);
            },
            onSwitchConfigs: (ReaderSupportConfigs configs) async {
              _configs = configs;

              Storage.set('book', _configs);

              if (configs.index != _index) {
                load(configs.index, true);
              }
            },
          ),
        ],
      ),
    );
  }
}
