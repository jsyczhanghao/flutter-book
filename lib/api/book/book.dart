import '../../libs/libs.dart';
import '../../models/models.dart';
import './status.dart';

abstract class BookApi {
  final String id;
  final int type = -1;
  static const CHAPTERS_TABLE = 'chapters';
  static const MYS_TABLE = 'mys';
  static const BOOKS_TABLE = 'books';

  BookApi(this.id);

  Future<List<BookChapterModel>> chapters({
    int limit = 1000000,
    bool onlyUnCached = false,
  }) async {
    Database database = await _db();
    List<Map> chapters = await database.query(
      CHAPTERS_TABLE,
      limit: limit,
      where: !onlyUnCached ? null : 'cache = ?',
      whereArgs: !onlyUnCached ? null : [0],
    );

    if (chapters.length == 0 && !onlyUnCached) {
      chapters = await syncChapters();
    }

    return chapters.map((chapter) {
      return BookChapterModel.fromJson(chapter);
    }).toList();
  }

  Future<bool> try2syncChapters() async {
    int count = await getChaptersCount();

    if (count == 0) {
      List chapters = await syncChapters();

      if (chapters.length == 0) return false;
    }

    return true;
  }

  Future<List> syncChapters() async {
    List<Map> chapters;

    try {
      chapters = await getOnlineChapters();
    } catch (e) {
      return chapters;
    }

    Database database = await _db();

    await database.delete(CHAPTERS_TABLE);
    await database.transaction((tx) async {
      Batch batch = tx.batch();
      int i = 0;

      chapters = chapters.map((chapter) {
        Map<String, dynamic> _ = Map<String, dynamic>.from(chapter)
          ..addAll({'id': i++, 'cache': 0, 'bookid': id, 'type': type});

        batch.insert('chapters', _);
        return _;
      }).toList();

      await batch.commit();
    });

    return chapters;
  }

  Future<List<Map>> getOnlineChapters();

  Future<int> getChaptersCount({bool onlyUnCached = false}) async {
    Database database = await _db();
    List res = await database.rawQuery(
        'SELECT COUNT(id) AS count FROM $CHAPTERS_TABLE' +
            (onlyUnCached ? ' WHERE cache = 0' : ''));

    if (res.length == 0) {
      return 0;
    }

    return res[0]['count'];
  }

  saveProgress(int chapter, int page) async {
    await _store().writeJson({
      'chapter': chapter,
      'page': page,
    });
  }

  Future<Map<String, int>> getProgress() async {
    Map<String, dynamic> info = await _store().readJson();

    if (info == null) {
      return {
        'chapter': 0,
        'page': 0,
      };
    } else {
      return {
        'chapter': info['chapter'].toInt(),
        'page': info['page'].toInt(),
      };
    }
  }

  Future<BookModel> model() async {
    Database database = await DatabaseFactory.getAInstance();
    List<Map> list = await database.rawQuery(
      'SELECT * FROM books LEFT OUTER JOIN mys USING (id, type) WHERE id = ? AND type = ? LIMIT 1',
      [id, type],
    );

    return list.length == 1 ? BookModel.fromJson(list[0]) : null;
  }

  Future<void> save(BookModel book) async {
    Database database = await DatabaseFactory.getAInstance();
    await database.execute(
      'REPLACE INTO $BOOKS_TABLE (id, type, name, img, intro) VALUES(?, ?, ?, ?, ?)',
      [id, type, book.name, book.img, book.intro],
    );
  }

  Future<void> collect() async {
    Database database = await DatabaseFactory.getAInstance();
    await saveStatus(BookStatus.COLLECTED);
  }

  Future<void> delete() async {
    Database database = await DatabaseFactory.getAInstance();
    await database.execute(
        'DELETE FROM $MYS_TABLE WHERE id = ? AND type = ?', [id, type]);
  }

  Future<void> download() async {
    await try2syncChapters();
    await saveStatus(BookStatus.DOWNLOADING);
  }

  Future<void> saveStatus(int status) async {
    Database database = await DatabaseFactory.getAInstance();
    await database.execute(
      'REPLACE INTO $MYS_TABLE (id, type, status, time) VALUES(?, ?, ?, CURRENT_TIMESTAMP)',
      [id, type, status],
    );
  }

  Future<Database> _db() async {
    return await DatabaseFactory.getEBInstance('$type/$id');
  }

  Store _store() {
    return Store('$type/$id/progress');
  }

  static Future<List<BookModel>> list({int status, int limit = 1000000}) async {
    Database database = await DatabaseFactory.getAInstance();
    String condition = status != null ? ' WHERE mys.status = ${status}' : '';

    List<Map> books = await database.rawQuery(
      'SELECT * FROM books INNER JOIN mys USING (id, type)' +
          condition +
          ' ORDER BY time DESC LIMIT $limit',
    );

    return books.map((book) {
      return BookModel.fromJson(book);
    }).toList();
  }
}
