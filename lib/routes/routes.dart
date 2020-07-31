import 'package:flutter/material.dart';
import '../views/book/detail.dart';
import '../views/book/chapters.dart';
import '../views/book/read.dart';
import '../views/book/tts.dart';

Map<String, Widget Function(BuildContext)> initializeRoutes() {
  return {
    '/book/detail': (BuildContext context) =>
        BookDetailView(book: ModalRoute.of(context).settings.arguments),
    '/book/chapters': (BuildContext context) =>
        BookChaptersView(book: ModalRoute.of(context).settings.arguments),
    '/book/read': (BuildContext context) {
      return ReadView(book: ModalRoute.of(context).settings.arguments);
    },
    '/book/read/iftts': (BuildContext context) {
      return ReadView(book: ModalRoute.of(context).settings.arguments, iftts: true);
    },
    '/book/tts': (BuildContext context) {
      return TtsView(book: ModalRoute.of(context).settings.arguments);
    },
    '/book/iftts': (BuildContext context) {
      return TtsView(book: ModalRoute.of(context).settings.arguments, iftts: true);
    },
  };
}