import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './book.dart';

final RegExp chaptersRegExp = RegExp(
  r'<a [\s\S]+?href="([^"]+)"[^>]*>\s*<span class="ellipsis ">([^<]+)',
);

class KBookApi extends BookApi {
  final int type = Types.K;

  KBookApi(String id) : super(id);

  @override
  Future<List<Map>> getOnlineChapters() async {
    return Helper.fetch.get('${Domains.CHAPTERS_K}/list/$id.html').then((data) {
      return chaptersRegExp.allMatches(data.data).map((m) {
        return {
          'url': m[1],
          'title': m[2].trim(),
        };
      }).toList();
    });
  }
}