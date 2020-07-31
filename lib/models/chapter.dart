import './book.dart';

class BookChapterModel {
  final int id;
  final String bookid;
  final String title;
  final String url;
  final int type;
  final String content;
  final int cache;
  final BookModel book;

  BookChapterModel({
    this.id,
    this.bookid,
    this.title,
    this.url,
    this.type,
    this.content,
    this.cache,
    this.book,
  });

  BookChapterModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookid = json['bookid'],
        title = json['title'],
        url = json['url'],
        type = json['type'],
        content = json['content'],
        cache = json['cache'],
        book = json['book'] == null ? null : BookModel.fromJson(json['book']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'bookid': bookid,
        'title': title,
        'url': url,
        'type': type,
        'content': content,
        'cache': cache,
        'book': book == null ? null : book.toJson(),
      };
}
