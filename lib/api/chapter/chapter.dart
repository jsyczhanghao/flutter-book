import '../../libs/libs.dart';
import '../../models/models.dart';

abstract class BookChapterApi {
  final String bookid;
  final int type = -1;
  final int index;
  String dir;
  static const CHAPTERS_TABLE = 'chapters';

  BookChapterApi(this.bookid, this.index);

  Future<BookChapterModel> model() async {
    if (index < 0) return null;

    Database database = await _db();
    List<Map> chapters = await database.rawQuery(
      'SELECT * FROM $CHAPTERS_TABLE WHERE id = ? LIMIT 1',
      [index],
    );

    return chapters.length == 1 ? BookChapterModel.fromJson(chapters[0]) : null;
  }

  Future<BookChapterModel> modelWithContent() async {
    if (index < 0) return null;

    String content = await _local();

    if (content == null) {
      content = await download();
    }

    if (content == null) return null;

    BookChapterModel chapter = await model();

    return BookChapterModel.fromJson(Map.from(chapter.toJson()..addAll({
      'content': content,
    })));
  }

  Future<String> _local() async {
    if (index < 0) return null;

    Store store = Store('$type/$bookid/$index.txt');
    String content = await store.read();

    return content;
  }

  Future<String> download([String url]) async {
    if (url == null) {
      BookChapterModel chapter = await model();

      if (chapter != null) {
        url = chapter.url;
      } else {
        return null;
      }
    }

    String content;

    try {
      content = await getOnlineChapterContent(url);
    } catch (e) {
      return null;
    }
    
    content = content
        .trim()
        .replaceAll(RegExp(r'^[\r\n]| |　　'), '')
        .replaceAll(RegExp(r'[\r\n]{2,}'), '\n')
        .split(RegExp(r'[\r\n]'))
        .map((str) {
          return '　　' + str;
        })
        .toList()
        .join('\n');
    Store store = Store('$type/$bookid/$index.txt');
    await store.write(content);

    Database database = await _db();
    await database.execute(
        'UPDATE $CHAPTERS_TABLE SET cache = 1 WHERE id = ?', [index]);
    return content;
  }

  Future<String> getOnlineChapterContent(url);

  Future<Database> _db() async {
    return await DatabaseFactory.getEBInstance('$type/$bookid');
  }
}
