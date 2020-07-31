import 'package:flutter/material.dart';

class PagingData {
  final Size size;
  final Size max;
  final int pages;

  PagingData({this.size, this.max, this.pages});
}

class PagingAnalyser {
  static PagingAnalyser instance;
  static const INLINE_HEIGHT_SCALE = 1.5;
  static const TRY_MAX_COUNT = 60;
  static Map<double, double> heightsCache = Map<double, double>();
  static final TEST_TEXT = List(100).map((x) => 'A').toList().join('\n');
  final Size limitSize;

  factory PagingAnalyser(limitSize) => getInstance(limitSize);

  PagingAnalyser._internal(this.limitSize);

  static PagingAnalyser getInstance(limitSize) {
    if (instance == null) {
      instance = PagingAnalyser._internal(limitSize);
    }

    return instance;
  }

  PagingData analyse({String text, TextStyle style}) {
    Map data = test(style, 0);
    double maxHeight = testPainterHeight(text, style);
    int pages = (maxHeight / data['height']).ceilToDouble().toInt();

    return PagingData(
      size: Size(limitSize.width, data['height']),
      max: Size(limitSize.width, maxHeight),
      pages: pages,
    );
  }

  Map test(TextStyle style, int page, [String text]) {
    if (text == null) {
      text = TEST_TEXT;
    }

    int start = 0;
    int end = text.length;
    int mid = (end + start) ~/ 2;
    double limitHeight = limitSize.height * (page + 1);
    double height;

    for (int i = 0; i < TRY_MAX_COUNT; i++) {
      height = testPainterHeight(text.substring(0, mid), style);

      if (height < limitHeight) {
        if (mid <= start || mid >= end) {
          break;
        }
        start = mid;
        mid = (start + end) ~/ 2;
      } else {
        end = mid;
        mid = (start + end) ~/ 2;
      }
    }

    return {'height': height, 'index': mid};
  }

  double testPainterHeight(String text, TextStyle style) {
    TextPainter painter = TextPainter(
      textScaleFactor: 1,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: style,
      ),
    );

    painter.layout(maxWidth: limitSize.width);
    return painter.height;
  }
}
