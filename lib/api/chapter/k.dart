import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './chapter.dart';

final RegExp chapterContentRegExp = RegExp(r'<div class="(?:p|content)">[\s\S]*?(?=<p class="copy)');
final RegExp chapterContentLineRegExp = RegExp(r'<p>([\s\S]+?)</p>');

class KBookChapterApi extends BookChapterApi {
  final int type = Types.K;

  KBookChapterApi(String id, int index) : super(id, index);

  @override
  Future<String> getOnlineChapterContent(url) {
    return Helper.fetch.get(Domains.CHAPTERS_K + url).then((data) {
      String html = chapterContentRegExp.stringMatch(data.data);
      return chapterContentLineRegExp.allMatches(html ?? '').map((m) {
        return m[1];
      }).toList().join('\n');
    });
  }
}