import 'package:flutter/material.dart';

class ReaderSize{
  MediaQueryData queryData;
  static const double PADDING_LR = 10;
  static const double PADDING_TB = 20;

  ReaderSize(BuildContext context) {
    queryData = MediaQuery.of(context);
  }

  double get width {
    return queryData.size.width - PADDING_LR * 2;
  }

  double get height {
    return queryData.size.height - queryData.padding.top * 2;
  }
}