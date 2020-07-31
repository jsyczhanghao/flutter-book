import 'package:flutter/material.dart';
import '../../libs/libs.dart';
import '../../api/api.dart';
import '../../tasks/download/download.dart';
import '../../components/tts/iftts.dart';

class BookDetailView extends StatelessWidget {
  final BookModel book;

  BookDetailView({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.name),
        ),
        body: IfTts(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Image(
                  image: Helper.image(book.img),
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Text(book.intro),
                  ),
                ),
              ),
              BookDetailActions(book: book)
            ],
          ),
        ));
  }
}

class BookDetailActions extends StatefulWidget {
  final BookModel book;

  BookDetailActions({Key key, this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookDetailActionsState();
  }
}

class BookDetailActionsState extends State<BookDetailActions> {
  BookModel _model;
  BookApi api;

  @override
  initState() {
    super.initState();
    _model = widget.book;
    api = BookApiFactory.create(widget.book.id, widget.book.type);
    load();
  }

  load() async {
    _model = await api.model();
    setState(() {});
  }

  go2read() async {
    bool synced = await Helper.loading(api.try2syncChapters(), context);

    if (!synced) return;

    Navigator.pushNamed(context, '/book/read', arguments: _model);
  }

  download() async {
    await Helper.loading(DownloadManager.getInstance().add(_model), context,
        title: '获取资源中', success: '添加下载任务成功');
    load();
  }

  collect() async {
    await Helper.loading(api.collect(), context, success: '成功添加至书架');
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BookDetailAction.HEIGHT,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.05))),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          _model.status == BookStatus.NONE
              ? BookDetailAction(
                  icon: Icons.add,
                  text: '收藏',
                  color: Colors.transparent,
                  onPressed: () => collect(),
                )
              : Container(),
          _model.status == BookStatus.NONE ||
                  _model.status == BookStatus.COLLECTED
              ? BookDetailAction(
                  icon: Icons.cloud_download,
                  text: '下载',
                  color: Colors.transparent,
                  onPressed: () => download(),
                )
              : Container(),
          BookDetailAction(
            icon: Icons.chat,
            text: '阅读',
            color: Colors.blue,
            onPressed: () => go2read(),
          ),
        ],
      ),
    );
  }
}

class BookDetailAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;
  final int flex;
  static const double HEIGHT = 45;

  BookDetailAction(
      {Key key,
      this.icon,
      this.color,
      this.text,
      this.onPressed,
      this.flex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: FlatButton.icon(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        label: Container(
          alignment: Alignment.center,
          height: 45,
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
