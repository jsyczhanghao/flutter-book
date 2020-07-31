import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './book.dart';

final RegExp htmlRegExp = RegExp(r'(?<=pc_list[\s\S]+?正文[\s\S]+?)<ul>([\s\S]+?)<\/ul>');
final RegExp chaptersRegExp =
    RegExp(r'<li><a href="([^"]+)">([^<]+?)<\/a><\/li>');

class XsBookApi extends BookApi {
  final int type = Types.XS;

  XsBookApi(String id) : super(id);

  @override
  Future<List<Map>> getOnlineChapters() async {
    String url = '${Domains.CHAPTERS_XS}/book/$id';

    return Helper.fetch.get(url).then((data) {
      String html = htmlRegExp.stringMatch(data.data);

      return chaptersRegExp.allMatches(html).map((m) {
        return {
          'url': url + '/' + m[1],
          'title': m[2],
        };
      }).toList();
    });
  }
}
