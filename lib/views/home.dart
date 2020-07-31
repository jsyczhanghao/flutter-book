import 'package:flutter/material.dart';
import '../libs/helper.dart';
import '../models/models.dart';
import '../components/common/books.dart';
import '../api/api.dart';
import '../api/book/factory.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  List<BookModel> _books = List<BookModel>();
  String _word = '';
  bool wantKeepAlive = true;

  initState() {
    super.initState();
    Future(() => load());
  }

  load([String word]) async {
    _books = await Helper.loading(SearchApi.query(word ?? _word), context,
        title: '玩命加载中');
    setState(() {});
  }

  setWord([String word]) {
    setState(() {
      _word = word ?? '';
    });
  }

  InputDecoration get _decoration {
    return InputDecoration(
      prefixIcon: Icon(
        Icons.search,
        color: Colors.black54,
      ),
      hintText: '输入小说名进行搜索',
      suffixIcon: Container(
        width: 20,
        height: 20,
        child: _word == ''
            ? null 
            : IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.highlight_off, size: 18, color: Colors.black54,),
                onPressed: setWord,
              ),
      ),
      hintStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderSide: BorderSide.none),
    );
  }

  TextEditingController get _controller {
    return TextEditingController.fromValue(
      TextEditingValue(
        text: _word,
        selection: new TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: _word.length,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          style: TextStyle(
            color: Colors.black87,
          ),
          cursorColor: Colors.black87,
          onChanged: setWord,
          onSubmitted: load,
          decoration: _decoration,
        ),
      ),
      body: Books(
        books: _books,
        onClickBook: (BookModel book, int index) async {
          await BookApiFactory.create(book.id, book.type).save(book);
          Navigator.pushNamed(context, '/book/detail', arguments: book);
        },
      ),
    );
  }
}
