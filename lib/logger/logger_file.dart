part of logger;

class LoggerFile {
  LoggerConfig _config;
  LoggerFile._();

  static final LoggerFile _singleton = LoggerFile._();

  static LoggerFile getInstance(LoggerConfig config) {
//    //清理7日前的日志
//    String path = config.fileDirectory;
//    if (path.endsWith("/")) {
//      path = path.substring(0, path.length - 1);
//    }
//    if (Platform.isIOS) {
//      var directory = await _appPath;
//      path = join(directory, "logs");
//    }
//
//    var directory = new Directory(path);
//    List<FileSystemEntity> files = directory.listSync();
//    files.sort((left, right) => left.path.compareTo(right.path));
//    if (files != null && files.length > 7) {
//      for (int i = 0; i < files.length - 7; i++) {
//        var f = files[i];
//        print(files[i].path);
//        f.deleteSync();
//      }
//    }

    _singleton._config = config;
    return _singleton;
  }

  Future<String> readLog() async {
    try {
      final file = await _file;
      return file.readAsString();
    } catch (err) {
      throw err;
    }
  }

  Future writeLog(String log) async {
    try {
      final file = await _file;
      IOSink skin = file.openWrite(mode: FileMode.append);
      skin.write(log + "\n");
      skin.close();
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future<String> get _appPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    String path = _config.fileDirectory;
    if (path.endsWith("/")) {
      path = path.substring(0, path.length - 1);
    }
    if (Platform.isIOS) {
      var directory = await _appPath;
      path = join(directory, "logs");
    }

    await Directory(path).create(recursive: true);

    String fileName = LoggerUtils.getCurrentDateString();
    File file = File("$path/$fileName.log");

    return file;
  }
}
