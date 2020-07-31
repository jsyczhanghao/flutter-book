import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './chapter.dart';

final RegExp chapterContentHtmlRegExp = RegExp(
    r'<div id="nr1">([\s\S]+?)<\/div>');
final RegExp chapterContentLineRegExp = RegExp(r'<p>([\s\S]+?)<\/p>');

class LxBookChapterApi extends BookChapterApi {
  final int type = Types.LX;

  LxBookChapterApi(String id, int index) : super(id, index);

  @override
  Future<String> getOnlineChapterContent(url) {
    return Helper.fetch.get(url).then((data) {
      String html = chapterContentHtmlRegExp.stringMatch(data.data);
    
      return chapterContentLineRegExp.allMatches(html).map((m) {
        return m[1].replaceAll(RegExp(r'<[^>]+>'), '');
      }).toList().join('\n');
    });
  }
}
