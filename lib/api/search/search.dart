import '../../models/models.dart';
import './k.dart';
import './xs.dart';
import './qd.dart';
import './lx.dart';
import '../../libs/libs.dart';

class SearchApi {
  static Future<List<BookModel>> query(String word) {
    List<Future> querys = [
      LxSearchApi.query(word),
      KSearchApi.query(word),
      QdSearchApi.query(word),
      XsSearchApi.query(word),
    ];

    return Future.wait(querys).then((List arr) async {
      List<Map> all = [];

      arr.forEach((a) {
        all.addAll(a);
      });

      List<BookModel> books = all.map((Map book) {
        book['name'] = book['name'].trim();
        book['intro'] = book['intro']?.replaceAll(RegExp(r' |&[^;]+;'), '');
        return BookModel.fromJson(book);
      }).toList();

      //缓存更新
      await store(books);

      if (word == '') return books;

      books.sort((a, b) {
        int ai = a.name.indexOf(word);
        int bi = a.name.indexOf(word);

        if (ai == 0 || bi == -1) return 1;
        if (bi == 0 || ai == -1) return -1;

        return ai < bi ? 1 : -1;
      });
    
      return books;
    });
  }

  static store(List<BookModel> books) async {
    Database database = await DatabaseFactory.getAInstance();

    await database.transaction((tx) async {
      Batch batch = tx.batch();

      books.map((BookModel book) {
        batch.execute(
          'REPLACE INTO books (id, type, name, img, intro) VALUES(?, ?, ?, ?, ?)',
          [book.id, book.type, book.name, book.img, book.intro],
        );
      });

      await batch.commit();
    });
  }
}
