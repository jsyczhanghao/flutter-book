import 'package:audio_service/audio_service.dart';
import 'package:easytts/easytts.dart';
import 'dart:async';
import './actions.dart';
import './storage.dart';
import '../../api/api.dart';
import '../../libs/libs.dart';

void ttsBGEntry() {
  AudioServiceBackground.run(() => TtsBGTask());
}

class TtsBGTask extends BackgroundAudioTask {
  BookChapterModel chapter;
  BookModel book;
  int position = 0;
  int skip = 0;
  bool loading = false;
  static const MAX = 20 * 60 * 60;

  BasicPlaybackState get _basicState => AudioServiceBackground.state.basicState;

  Future<BookChapterModel> load(int index) async {
    if (loading) return null;

    loading = true;

    BookChapterApi api =
        BookChapterApiFactory.create(book.id, book.type, index);
    BookChapterModel model = await api.model();
    BookChapterModel _ = await api.modelWithContent();

    loading = false;

    if (model == null) return null;

    return BookChapterModel.fromJson(chapter.toJson()
      ..addAll({
        'content': _ == null ? null: _.content,
        'title': model.title,
        'id': model.id,
      }));
  }

  @override
  Future<void> onStart() async {
    TtsStorage storage = await TtsStorage.get();
    chapter = storage.model;
    book = storage.model.book;
    Easytts.on(listen);

    await play(storage.model.id);

    for (int i = 0; i < MAX && _basicState != BasicPlaybackState.stopped; i++) {
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void listen(EasyttsEvent event, [dynamic data]) async {
    switch (event) {
      case EasyttsEvent.WILL:
        position = 100 * (data['index'] + skip) ~/ chapter.content.length;
        await onPlay();
        break;

      case EasyttsEvent.FINISH:
        onSkipToNext();
        break;

      case EasyttsEvent.PAUSE:
        onPause();
        break;

      default:
        break;
    }
  }

  Future<void> play(int id) async {
    BookChapterModel model = await load(id);

    if (model == null) {
      model = await load(0);

      if (model == null) return ;
    }

    print(model);

    chapter = model;
    BookApi api = BookApiFactory.create(book.id, book.type);
    await api.saveProgress(chapter.id, 0);
    await TtsStorage.set(chapter, status: TtsStorageStatus.READY);

    AudioServiceBackground.setMediaItem(MediaItem(
      id: 'tts_$id',
      album: model.title,
      title: model.book.name,
    ));

    AudioServiceBackground.setState(
      controls: [PAUSE_CONTROL, STOP_CONTROL],
      basicState: BasicPlaybackState.connecting,
      position: 0,
    );

    skip = 0;
    position = 0;
    speak(model.content);
  }

  speak(String text) async {
    Easytts.stop();
    Easytts.setLanguage('zh-CN');

    if (text == null) {
      await TtsStorage.set(chapter, status: TtsStorageStatus.READY);
      AudioServiceBackground.setState(
        controls: [PAUSE_CONTROL, STOP_CONTROL],
        basicState: BasicPlaybackState.buffering,
        position: 0,
      );
      return ;
    }

    Easytts.speak(text);
    TtsStorage.set(chapter, status: TtsStorageStatus.PLAYING);
    onPlay();
  }

  @override
  Future<void> onPlay() async {
    if (_basicState != BasicPlaybackState.playing) {
      Easytts.resume();
      await TtsStorage.set(chapter, status: TtsStorageStatus.PLAYING);
    }

    await AudioServiceBackground.setState(
      controls: [PAUSE_CONTROL, STOP_CONTROL],
      basicState: BasicPlaybackState.playing,
      position: position,
    );
  }

  @override
  void onPause() async {
    if (_basicState != BasicPlaybackState.paused) {
      Easytts.pause();
      await TtsStorage.set(chapter, status: TtsStorageStatus.PAUSED);
    }
    
    AudioServiceBackground.setState(
      controls: [PLAY_CONTROL, STOP_CONTROL],
      basicState: BasicPlaybackState.paused,
      position: position,
    );
  }

  @override
  void onSkipToNext() async {
    AudioServiceBackground.setState(
      controls: [],
      basicState: BasicPlaybackState.skippingToNext,
      position: position,
    );

    await play(chapter.id + 1);
  }

  @override
  void onSkipToPrevious() async {
    AudioServiceBackground.setState(
      controls: [],
      basicState: BasicPlaybackState.skippingToPrevious,
      position: position,
    );
    await play(chapter.id - 1);
  }

  @override
  void onSeekTo(int pos) {
    if (chapter.content == null) return;

    position = pos;
    skip = chapter.content.length * pos ~/ 100;
    speak(chapter.content.substring(skip));
  }

  @override
  void onStop() async {
    Easytts.off(listen);
    Easytts.stop();
    
    AudioServiceBackground.setState(
      controls: [],
      basicState: BasicPlaybackState.stopped,
    );
  }

  /// Called on Android when your app gains the audio focus.
  void onAudioFocusGained() {
    print('fjk12333');
  }

  /// Called on Android when your app loses audio focus for an unknown
  /// duration.
  void onAudioFocusLost() {
    print('loast3');
  }

  /// Called on Android when your app loses audio focus temporarily and should
  /// pause audio output for that duration.
  void onAudioFocusLostTransient() {
    print('lost2');
  }

  /// Called on Android when your app loses audio focus temporarily and may
  /// lower the audio output volume for that duration.
  void onAudioFocusLostTransientCanDuck() {
    print('lost1');
  }

  /// Called on Android when your audio output is about to become noisy due
  /// to the user unplugging the headphones.
  void onAudioBecomingNoisy() {
    print('becoming noisy');
  }

  /// Called when a custom action has been sent by the client via
  /// [AudioService.customAction].
  void onCustomAction(String name, dynamic arguments) {
    print('becoming custom');
  }
}
