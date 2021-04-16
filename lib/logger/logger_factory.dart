part of logger;

typedef Logger LoggerBuilder(LoggerConfig config);

class FLogger {
  static LoggerConfig _config = LoggerConfigImpl.instance;
  static LoggerBuilder _builder = (c) => LoggerImpl(c);
  static Logger _log = _builder(_config);

  static customBuilder(LoggerBuilder builder, {LoggerConfig config}) {
    if (config != null) {
      _config = config;
    }
    _log = builder(_config);
  }

  static updateConfig({
    LoggerLevel printLevel,
    LoggerLevel fileLevel,
    String fileDirectory,
    LoggerLevel serverLevel,
    String serverUrl,
  }) {
    _config.updateConfig(
      printLevel: printLevel,
      fileLevel: fileLevel,
      fileDirectory: fileDirectory,
      serverLevel: serverLevel,
      serverUrl: serverUrl,
    );
  }

  static trace(dynamic message) => _log.trace(message);
  static debug(dynamic message) => _log.debug(message);
  static info(dynamic message) => _log.info(message);
  static warn(dynamic message) => _log.warn(message);
  static error(dynamic message) => _log.error(message);
  static fatal(dynamic message) => _log.fatal(message);
}
