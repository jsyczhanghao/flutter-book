import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../components/tts/player.dart';

class TtsView extends StatefulWidget {
  final BookModel book;
  final bool iftts;

  TtsView({Key key, this.book, this.iftts = false}) : super(key: key);

  @override
  TtsViewState createState() {
    return TtsViewState();
  }
}

class TtsViewState extends State<TtsView> {
  BookApi api;
  int _chapter;
  static const double ICON_SIZE = 40;

  @override
  void initState() {
    super.initState();
    _ready();
  }

  _ready() async {
    if (!widget.iftts) {
      api = BookApiFactory.create(widget.book.id, widget.book.type);
      Map progress = await api.getProgress();
      _chapter = progress['chapter'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat, color: Colors.white),
            onPressed: () async {
              if (widget.iftts) {
                dynamic chapter = await Navigator.pushNamed(context, '/book/read/iftts', arguments: widget.book);

                if (chapter != null) {
                  setState(() {
                    _chapter = chapter;
                  });
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () async {
              dynamic chapter = await Navigator.pushNamed(
                context,
                '/book/chapters',
                arguments: widget.book,
              );

              if (chapter != null) {
                setState(() {
                  _chapter = chapter;
                });
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          widget.iftts || _chapter != null ? TtsPlayer(
            book: widget.book,
            chapter: _chapter,
          ) : Container(),
        ],
      ),
    );
  }

  // String analyseContentByPage(String text, int page) {
  //   String configs = Storage.get('book');
  //   ReaderSupportConfigs _configs = ReaderSupportConfigs();

  //   if (configs != null) {
  //     Map cfgs = jsonDecode(configs);

  //     _configs = ReaderSupportConfigs(
  //         fontFamily: cfgs['fontFamily'], fontSize: cfgs['fontSize']);
  //   }

  //   ReaderSize size = ReaderSize(context);
  //   Map info = PagingAnalyser.getInstance(Size(size.width, size.height)).test(
  //     TextStyle(
  //       fontSize: _configs.fontSize,
  //       fontFamily: _configs.fontFamily,
  //       height: PagingAnalyser.INLINE_HEIGHT_SCALE,
  //     ),
  //     page,
  //     text,
  //   );

  //   return text.substring(info['index']);
  // }
}
