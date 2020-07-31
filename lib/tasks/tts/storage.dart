import 'dart:async';
import '../../api/api.dart';
import '../../libs/libs.dart';

class TtsStorageStatus {
  static const int READY= 0;
  static const int PLAYING = 1;
  static const int STOPED = 3;
  static const int PAUSED = 2;
}

class TtsStorage {
  final int status;
  final BookChapterModel model;
  static const FILENAME = 'tts.txt';

  TtsStorage({this.status, this.model});

  static Future<void> clear() async {
    Store store = Store(FILENAME);
    await store.write('');
  }

  static Future<void> set(
    BookChapterModel chapter, {
    int status = TtsStorageStatus.PLAYING,
  }) async {
    Store store = Store(FILENAME);
    await store.writeJson({
      'status': status,
      'model': chapter,
    });
  }

  static Future<TtsStorage> get() async {
    Store store = Store(FILENAME);
    Map json = await store.readJson();

    if (json == null) return null;

    return TtsStorage(status: json['status'], model: BookChapterModel.fromJson(json['model']));
  }
}
