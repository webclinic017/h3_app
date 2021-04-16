part of logger;

abstract class LoggerConfig {
  LoggerLevel printLevel;
  LoggerLevel fileLevel;
  String fileDirectory;
  LoggerLevel serverLevel;
  String serverUrl;

  void updateConfig({
    LoggerLevel printLevel,
    LoggerLevel fileLevel,
    String fileDirectory,
    LoggerLevel serverLevel,
    String serverUrl,
  });
}

abstract class Logger {
  void trace(dynamic message);
  void debug(dynamic message);
  void info(dynamic message);
  void warn(dynamic message);
  void error(dynamic message);
  void fatal(dynamic message);
}

abstract class Log {
  String timestamp;
  String level;
  String stackMember;
  String message;
  List<dynamic> additional;

  Map<String, dynamic> toJson();
}