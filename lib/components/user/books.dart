import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../common/books.dart';

class UserBooks extends StatefulWidget {
  final int status;
  final Function onClickEmptyButton;
  UserBooks({Key key, this.status, this.onClickEmptyButton}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserBooksState();
  }
}

class UserBooksState extends State<UserBooks> {
  List<BookModel> books = List();

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    books = await BookApi.list(status: widget.status);
    
    if (mounted) {
      setState(() {});
    }
  }

  Widget renderItem(Widget item, int index) {
    return item;
  }

  onClickItem(BookModel book, int index) {
    Navigator.pushNamed(context, '/book/read', arguments: book);
  }

  onDismissed(BookModel book, int index) {
    books.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return books.length == 0
        ? Center(
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: widget.onClickEmptyButton,
            ),
          )
        : Books(
            books: books,
            onClickBook: onClickItem,
            onRenderItem: (Widget item, int index) {
              BookModel book = books[index];

              return Dismissible(
                key: Key('Key_${book.type}@${book.id}'),
                child: renderItem(item, index),
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete),
                ),
                onDismissed: (DismissDirection direction) =>
                    onDismissed(book, index),
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.endToStart) {
                    BookApi api = BookApiFactory.create(book.id, book.type);
                    await api.delete();
                    return true;
                  }

                  return false;
                },
              );
            },
          );
  }
}
