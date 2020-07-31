import 'package:flutter/material.dart';
import 'package:tf_toast/Toast.dart';
import 'package:dio/dio.dart';

export 'package:dio/dio.dart';
export 'package:tf_toast/Toast.dart';

class Helper {
  static Dio dio;

  static Future loading(Future api, BuildContext context, {String title, String success}) {
    Toast.show(context, title: title ?? '加载中', duration: 11);

    return api.then((res) {
      success != null ? Toast.show(context, title: success, duration: 1) : Toast.dismiss();
      return Future.value(res);
    }, onError: (e) {
      Toast.show(context, title: '网络异常', duration: 1);
      return Future.error(e);
    });
  }

  static Dio get fetch {
    if (dio == null) {
      dio = Dio();
      dio.options.connectTimeout = 10000;
    }

    return dio;
  }

  static ImageProvider image(String img) {
    if (img == null || img == '') {
      return AssetImage('lib/assets/nocover.jpg');
    }

    return NetworkImage(img);
  }
}
