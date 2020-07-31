import '../../configs/configs.dart';
import './chapter.dart';
import './k.dart';
import './xs.dart';
import './qd.dart';
import './lx.dart';

export './chapter.dart';
export '../../models/models.dart';

class BookChapterApiFactory {
  static BookChapterApi create(String bookid, int type, int index) {
    BookChapterApi instance;
    
    switch (type) {
      case Types.K:
        instance = KBookChapterApi(bookid, index);
        break;

      case Types.XS:
        instance = XsBookChapterApi(bookid, index);
        break;

      case Types.QD:
        instance = QdBookChapterApi(bookid, index);
        break;

      case Types.LX:
        instance = LxBookChapterApi(bookid, index);
        break;
    }

    return instance;
  }
}