import '../../configs/configs.dart';
import '../../libs/libs.dart';
import './chapter.dart';

final RegExp chapterContentHtmlRegExp = RegExp(
    r'(?<=<div \s*class="read-content\s+j_readContent">)([\s\S]*?)(?=<\/div>)');
final RegExp chapterContentLineRegExp = RegExp(r'<p>');

class QdBookChapterApi extends BookChapterApi {
  final int type = Types.QD;

  QdBookChapterApi(String id, int index) : super(id, index);

  @override
  Future<String> getOnlineChapterContent(url) {
    return Helper.fetch.get(url).then((data) {
      String html = chapterContentHtmlRegExp.stringMatch(data.data);
      return html
          .replaceAll(RegExp(r'<\/p>|[\r\n]+'), '')
          .split(chapterContentLineRegExp)
          .join('\n');
    });
  }
}
