import 'package:audio_service/audio_service.dart';
import '../../models/models.dart';
import './storage.dart';
import './background.dart';

class TtsController {
  static bool tasking = false;

  static Future<void> init() async {
    TtsStorage storage = await TtsStorage.get();

    if (storage != null) {
      TtsStorage.set(storage.model, status: TtsStorageStatus.READY);
    }
  }

  static Future<void> speak(BookChapterModel chapter) async {
    tasking = true;
    await stop();
    await TtsStorage.set(chapter);

    await AudioService.start(
      backgroundTaskEntrypoint: ttsBGEntry,
      resumeOnClick: true,
      androidNotificationChannelName: 'js.zhang tts',
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  }

  static stop() async {
    try {
      await AudioService.stop();
      await TtsStorage.clear();
    } catch (e) {};
  }

  static resume() {
    AudioService.play();
  }

  static pause() {
    AudioService.pause();
  }

  static seek(int i) {
    AudioService.seekTo(i);
  }

  static skip2next() {
    AudioService.skipToNext();
  }

  static skip2previous() {
    AudioService.skipToPrevious();
  }
}
