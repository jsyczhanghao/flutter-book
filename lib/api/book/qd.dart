import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './book.dart';

final RegExp chaptersRegExp =
    RegExp(r'<li data-rid[^>]+><a href="(\/\/read[^"]+)"[^>]*>([\s\S]+?)<\/a>');

class QdBookApi extends BookApi {
  final int type = Types.QD;

  QdBookApi(String id) : super(id);

  @override
  Future<List<Map>> getOnlineChapters() async {
    String url = '${Domains.CHAPTERS_QD}/info/$id';

    return Helper.fetch.get(url).then((data) {
      return chaptersRegExp.allMatches(data.data).map((m) {
        return {
          'url': 'https:' + m[1],
          'title': m[2],
        };
      }).toList();
    });
  }
}
