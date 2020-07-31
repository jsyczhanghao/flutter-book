import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './book.dart';

final RegExp htmlRegExp = RegExp(r'(?:<div class="title clearfix">[\s\S]+?<a [^>]+>([\s\S]+?)<\/a>\s*<\/h3>\s*<\/div>\s*)?<div class="book-list clearfix">([\s\S]+?)<\/div>');
final RegExp chaptersRegExp =
    RegExp(r'<a [^>]+ href="([^"]+)">([\s\S]+?)<\/a>');

class LxBookApi extends BookApi {
  final int type = Types.LX;

  LxBookApi(String id) : super(id);

  @override
  Future<List<Map>> getOnlineChapters() async {
    String url = '${Domains.CHAPTERS_LX}/$id/';

    return Helper.fetch.get(url).then((data) {
      Iterable<RegExpMatch> matches = htmlRegExp.allMatches(data.data);
      List<Map> chapters = [];
      
      for (RegExpMatch match in matches) {
        chapters.addAll(chaptersRegExp.allMatches(match[2]).map((m) {
          return {
            'url': m[1],
            'title': match[1] != null ? match[1] + ' - ' + m[2] : m[2],
          };
        }));
      }

      return chapters;
    });
  }
}
