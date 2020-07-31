import 'package:flutter/material.dart';
import '../../libs/helper.dart';
import '../../api/api.dart';

class BookChaptersView extends StatelessWidget {
  final BookModel book;

  BookChaptersView({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('目录'),
      ),
      body: BookChapters(
        book: book,
      ),
    );
  }
}

class BookChapters extends StatefulWidget {
  final BookModel book;

  BookChapters({Key key, this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookChaptersState();
  }
}

class BookChaptersState extends State<BookChapters> {
  List<BookChapterModel> _chapters = List<BookChapterModel>();
  int _chapter;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future(() => loadChapters());
  }

  loadChapters() async {
    BookApi api = BookApiFactory.create(widget.book.id, widget.book.type);

    _chapters = await Helper.loading(
      Future.delayed(
        Duration(seconds: 1),
        () => api.chapters(),
      ),
      context,
    );

    setState(() {});

    Map progress = await api.getProgress();

    if (progress != null) {
      _chapter = progress['chapter'];
    } else {
      _chapter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(index);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: <Widget>[
                Text(
                  _chapters[index].title,
                  style: TextStyle(
                    fontSize: 16,
                    color: _chapter != index ? Colors.black : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: _chapters.length,
    );
  }
}
