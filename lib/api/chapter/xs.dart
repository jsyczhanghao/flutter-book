import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './chapter.dart';

final RegExp chapterContentHtmlRegExp =
    RegExp(r'(?<=<div \s*id="content1"[^>]*>)([\s\S]*?)(?=<\/div>)');
final RegExp chapterContentLineRegExp = RegExp(r'<br/>');

class XsBookChapterApi extends BookChapterApi {
  final int type = Types.XS;

  XsBookChapterApi(String id, int index) : super(id, index);

  @override
  Future<String> getOnlineChapterContent(url) {
    return Helper.fetch.get(url).then((data) {
      String html = chapterContentHtmlRegExp.stringMatch(data.data);
      return html
          .trim()
          .replaceAll('&nbsp;', '')
          .replaceAll(RegExp(r'\s+'), '')
          .split(chapterContentLineRegExp)
          .join('\n');
    });
  }
}
