import '../../configs/configs.dart';
import './book.dart';
import './k.dart';
import './xs.dart';
import './qd.dart';
import './lx.dart';

export './status.dart';
export './book.dart';
export '../../models/models.dart';

class BookApiFactory {
  static BookApi create(String id, int type) {
    BookApi instance;
    
    switch (type) {
      case Types.K:
        instance = KBookApi(id);
        break;

      case Types.XS:
        instance = XsBookApi(id);
        break;

      case Types.QD:
        instance = QdBookApi(id);
        break;

      case Types.LX:
        instance = LxBookApi(id);
        break;
    }

    return instance;
  }
}