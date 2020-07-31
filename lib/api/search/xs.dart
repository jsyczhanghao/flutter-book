import '../../libs/libs.dart';
import '../../configs/configs.dart';

final RegExp searchRegExp = RegExp(
  r'<li>\s*[\s\S]+?<a href="([^>]+)"><img src="([^"]+)">([^<]+)</a>\s*<div class="u">([\s\S]*?)</div>',
);
final RegExp idRegExp = RegExp(
  r'(?<=\d{8})([\d]+)(?=\.html)',
);

class XsSearchApi {
  static Future<List<Map>> query(String word) async {
    //if (word == '')  return List<Map>();

    try {
      Response data = await Helper.fetch
          .get('${Domains.SEARCH_XS}/search.php?s=&searchkey=$word');
      return searchRegExp.allMatches(data.data).map((m) {
        return {
          'id': idRegExp.stringMatch(m[1]),
          'img': Domains.SEARCH_XS + m[2],
          'type': Types.XS,
          'url': m[1],
          'name': m[3],
          'intro': m[4]
        };
      }).toList();
    } catch (e) {
      return List<Map>();
    }
  }
}
