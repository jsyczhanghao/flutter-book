import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../libs/libs.dart';
import '../../models/book.dart';

class Books extends StatefulWidget {
  final List<BookModel> books;
  final Function(BookModel, int) onClickBook;
  final Widget Function(Widget, int) onRenderItem;

  Books({Key key, this.books, this.onClickBook, this.onRenderItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BooksState();
  }
}

class BooksState extends State<Books> {
  List<BookModel> rows = List<BookModel>();
  ScrollController controller = ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();
    rows = widget.books;
  }

  @override
  void didUpdateWidget(Books oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.books != widget.books) {
      //controller.animateTo(0.0, duration: Duration(microseconds: 10), curve: Curves.bounceIn);
      setState(() {
        rows = widget.books;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
            height: 1,
          );
        },
        controller: controller,
        itemCount: rows.length,
        itemBuilder: (BuildContext context, int index) {
          BookModel book = rows[index];
          String intro = book.intro;

          if (intro.length > 60) {
            intro = intro.substring(0, 60) + '...';
          }

          Widget item = Container(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Image(
                  image: Helper.image(book.img),
                  width: 80,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.name,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            intro != '' ? intro : '暂无任何介绍~',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );

          if (widget.onRenderItem != null) {
            item = widget.onRenderItem(item, index);
          }

          return GestureDetector(
            key: Key('Key_${book.type}@{book.id}'),
            child: item,
            onTap: () => widget.onClickBook(book, index),
          );
        },
      ),
    );
  }
}
