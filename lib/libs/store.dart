import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Store {
  final String filename;

  Store(this.filename);

  Future<dynamic> readJson() async {
    String content = await read();

    if (content != null && content != '') {
      return jsonDecode(content);
    }

    return null;
  }

  Future<void> writeJson(dynamic json) async {
    await write(jsonEncode(json));
  }

  Future<String> read() async {
    try {
      File file = await Store.file(filename);
      return await file.readAsString();
    } on FileSystemException {
      return null;
    }
  }

  Future<void> write(String content) async {
    File file = await createFile(filename);
    await file.writeAsString(content);
  }

  static Future<File> file(path) async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$path');
  }

  static Future<File> createFile(path) async {
    File file = await Store.file(path);
    bool exists = await file.exists();

    if (!exists) {
      await file.create(recursive: true);
    }

    return file;
  }
}