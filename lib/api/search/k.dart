import '../../libs/libs.dart';
import '../../configs/configs.dart';

final RegExp searchRegExp = RegExp(
  r'<div class="textlist">[\s\S]+?<img src="([^"]+)"[\s\S]+?<dt>\s*<a href="([^"]+)"[^>]*>\s*([\S]+?)\s*<\/a>[\s\S]+?<li>[\s\S]+?<p>\s*<a[^>]+>([\s\S]*?)<\/a>',
);

class KSearchApi {
  static Future<List> query(String word) async {
    try {
      Response data = await Helper.fetch.get('${Domains.SEARCH_K}/search.xhtml?c.st=0&c.q=$word');

      return searchRegExp.allMatches(data.data).map((m) {
        return {
          'id': RegExp(r'([\d]+)(?=\.html)').stringMatch(m[2]),
          'img': m[1],
          'type': Types.K,
          'name': m[3],
          'intro': m[4]?.replaceAll(RegExp(r'\s+'), '')
        };
      }).toList();
    } catch (e) {
      return List<Map>();
    }
  }
}
