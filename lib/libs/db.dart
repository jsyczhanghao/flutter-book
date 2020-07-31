import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
export 'package:sqflite/sqflite.dart';

class DatabaseFactory {
  static Map<String, Database> instances = Map();

  static Future<Database> close(
    String namespace
  ) async {
    if (instances[namespace] != null) {
      await instances[namespace].close();
      instances[namespace] = null;
    }
  }

  static Future<Database> getInstance(
    String namespace,
    Future<void> Function(Database, int) onCreate,
  ) async {
    if (instances[namespace] == null) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      Database _ = await openDatabase(
        '$dir/$namespace/_.db',
        version: 1,
        onCreate: onCreate,
      );

      instances[namespace] = _;
    }

    return instances[namespace];
  }

  static Future<Database> getEBInstance(String dir) async {
    return getInstance(dir, (Database instance, int version) async {
      return await instance.execute(
        '''
        CREATE TABLE chapters (
          id INT NOT NULL,
          title TEXT NOT NULL,
          url TEXT NOT NULL,
          bookid TEXT NOT NULL,
          type INT NOT NULL,
          cache INT NOT NULL
        )
      ''',
      );
    });
  }

  static Future<Database> getAInstance() async {
    return getInstance('global', (Database instance, int version) async {
      //cacheStatus 0 下载ing 1已下载 >1准备中
      await instance.execute('''
        CREATE TABLE books (
          id TEXT NOT NULL,
          type INT NOT NULL,
          name TEXT NOT NULL,
          img TEXT,
          intro TEXT
        )
      ''');

      await instance.execute('CREATE UNIQUE INDEX book_pk ON books (id, type)');

      //status 0 下载ing 1已下载 >1准备中
      await instance.execute('''
        CREATE TABLE mys (
          id TEXT NOT NULL,
          type INT NOT NULL,
          status INT NOT NULL,
          time TimeStamp NOT NULL
        )
      ''');

      await instance.execute('CREATE UNIQUE INDEX mys_pk ON mys (id, type)');
    });
  }
}