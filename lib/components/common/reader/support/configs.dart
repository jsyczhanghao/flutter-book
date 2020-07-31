import 'dart:convert';
import 'package:flutter/widgets.dart';
import './const.dart';
import './action.dart';

class ReaderSupportConfigs {
  final double fontSize;
  final String fontFamily;
  final int index;
  final int total;
  final double progress;
  final int theme;
  final List<ReaderSupportAction> actions;

  ReaderSupportConfigs({
    this.fontSize = ReaderSupportConst.FONT_MIN_SIZE,
    this.fontFamily = ReaderSupportConst.DEFAULT_FONT,
    this.theme = ReaderSupportConst.DEFAULT_THEME,
    this.index = 0,
    this.total = 1,
    this.progress = 0,
    this.actions,
  });

  ReaderSupportConfigs.from(
    ReaderSupportConfigs configs, {
    double fontSize,
    String fontFamily,
    int theme,
    int index,
    int total,
    double progress,
    List<ReaderSupportAction> actions,
  })  : fontSize = fontSize ?? configs.fontSize,
        fontFamily = fontFamily ?? configs.fontFamily,
        theme = theme ?? configs.theme,
        index = index ?? configs.index,
        total = total ?? configs.total,
        progress = progress ?? configs.progress,
        actions = actions ?? configs.actions;

  String toString() {
    return jsonEncode({
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'theme': theme
    });
  }
}
