import '../../libs/libs.dart';
import '../../configs/configs.dart';

final RegExp searchRegExp = RegExp(
  r'<li class="cat-search-item"><a target="_blank" href="([^"]+)">([\s\S]+?)</a></li>',
);

class LxSearchApi {
  static Future<List> query(String word) async {
    if (word == '')  return List<Map>();

    try {
      Response data = await Helper.fetch.get('${Domains.SEARCH_LX}/?s=$word');

      return searchRegExp.allMatches(data.data).map((m) {
        return {
          'id': RegExp(r'([^\/]+)(\/[^\/]+)?\/?$').stringMatch(m[1]),
          'img': '',
          'type': Types.LX,
          'name': m[2],
          'intro': ''
        };
      }).toList();
    } catch (e) {
      return List<Map>();
    }
  }
}