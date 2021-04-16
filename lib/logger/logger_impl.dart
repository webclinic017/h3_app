part of logger;

class LoggerImpl implements Logger {
  factory LoggerImpl(LoggerConfig config) => LoggerImpl._(config, LoggerFile.getInstance(config), LoggerServer.getInstance(config));

  LoggerImpl._(this._config, this._logFile, this._logServer);

  final LoggerConfig _config;
  final LoggerFile _logFile;
  final LoggerServer _logServer;

  @override
  trace(dynamic message) {
    LoggerLevel level = LoggerLevel.trace;
    _log(message, level);
  }

  @override
  debug(dynamic message) {
    LoggerLevel level = LoggerLevel.debug;
    _log(message, level);
  }

  @override
  info(dynamic message) {
    LoggerLevel level = LoggerLevel.info;
    _log(message, level);
  }

  @override
  warn(dynamic message) {
    LoggerLevel level = LoggerLevel.warn;
    _log(message, level);
  }

  @override
  error(dynamic message) {
    LoggerLevel level = LoggerLevel.error;
    _log(message, level);
  }

  @override
  fatal(dynamic message) {
    LoggerLevel level = LoggerLevel.fatal;
    _log(message, level);
  }

  _log(dynamic message, LoggerLevel level) {
    if (message.runtimeType != String) {
      message = message.toString();
    }

    Log log = _getLog(message, level);
    String printString = "${log.timestamp} [${log.level}] [${log.stackMember}] : ${log.message}";

    if (_config.printLevel.index <= level.index) {
      //AnsiPen ansiPen = LoggerUtils.getColor(level);
      //print(ansiPen(printString));

      ///修复print打印内容不完整
      PrintUtils.v(printString);
    }
    if (_config.fileLevel.index <= level.index) {
      _logFile.writeLog(printString);
    }
//    if (_config.serverLevel.index <= level.index) {
//      _logServer.upload(log);
//    }
  }

  Log _getLog(String message, LoggerLevel level) {
    var date = DateTime.now();
    String currentTime = "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    String levelNmae = LoggerUtils.enumToString(level);
    String member = Trace.current().frames[4]?.member;
    return LogImpl(currentTime, levelNmae, member, message);
  }
}

class LogImpl extends Log {
  String timestamp;
  String level;
  String stackMember;
  String message;
  List<dynamic> additional;

  LogImpl(
    this.timestamp,
    this.level,
    this.stackMember,
    this.message, {
    this.additional,
  });

  Map<String, dynamic> toJson() => {'timestamp': timestamp, 'level': level, 'stackMember': stackMember, 'message': message};
}
