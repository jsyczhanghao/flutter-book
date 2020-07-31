import 'package:flutter/material.dart';

class ReaderSupportConst {
  static const COLOR = Color.fromRGBO(255, 255, 255, 0.9);
  static const ICON_COLOR = Colors.black;
  static const SELECTED_ICON_COLOR = Colors.blue;

  static const double FONT_MIN_SIZE = 16;
  static const double FONT_MAX_SIZE = 28;
  static const String DEFAULT_FONT = 'Sy';
  static const int DEFAULT_THEME = 0;
  static const List<Map> FONTS = [
    {
      'value': 'Sy',
      'name': '思源黑体'
    },

    {
      'name': '思源宋体',
      'value': 'Syst'
    },

    {
      'name': '濑户字体',
      'value': 'Seto'
    }
  ];

  static const List<Map> SETTINGS = [
    {
      'value': 0,
      'icon': Icons.tune
    },
    {
      'value': 1,
      'icon': Icons.tonality
    },
    {
      'value': 2,
      'icon': Icons.font_download
    },
  ];

  static final List<Map> THEMES = [
    {
      'value': 0,
      'decoration': BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/light.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      'color': Colors.black
    },
    {
      'value': 1,
      'decoration': BoxDecoration(
        color: Colors.black.withOpacity(0.9),
      ),
      'color': Colors.white
    },
  ];
}