import '../../libs/libs.dart';
import '../../configs/configs.dart';

final RegExp searchRegExp = RegExp(
  r'<li class="res-book-item"[^>]*>[\s\S]+?<img src="([^"]+)"[\s\S]+?<div class="book-mid-info"[\s\S]+?bid="([^"]+)"[^>]*>([\s\S]+?)</a>[\s\S]+?<p class="intro">([\s\S]+?)<\/p>',
);
final RegExp trimRegExp = RegExp(r'<[^>]+>');

class QdSearchApi {
  static Future<List<Map>> query(String word) async {
    try {
      Response data =
          await Helper.fetch.get('${Domains.SEARCH_QD}/search?kw=$word');

      return searchRegExp.allMatches(data.data).map((m) {
        return {
          'id': m[2],
          'img': 'https:' + m[1],
          'type': Types.QD,
          'name': m[3].replaceAll(trimRegExp, ''),
          'intro': m[4].replaceAll(trimRegExp, '')
        };
      }).toList();
    } catch (e) {
      return List<Map>();
    }
  }
}
