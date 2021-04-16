part of logger;

class LoggerConfigImpl implements LoggerConfig {
  LoggerLevel printLevel = LoggerConstants.defaultPrintLevel;
  LoggerLevel fileLevel = LoggerConstants.defaultFileLevel;
  String fileDirectory = LoggerConstants.defaultFileDirectory;
  LoggerLevel serverLevel = LoggerConstants.defaultServerLevel;
  String serverUrl = LoggerConstants.defaultServerUrl;

  LoggerConfigImpl._();
  static final LoggerConfigImpl _singleton = LoggerConfigImpl._();
  static LoggerConfig get instance => _singleton;

  updateConfig({
    LoggerLevel printLevel,
    LoggerLevel fileLevel,
    String fileDirectory,
    LoggerLevel serverLevel,
    String serverUrl,
  }) {
    if (printLevel != null) this.printLevel = printLevel;
    if (fileLevel != null) this.fileLevel = fileLevel;
    if (fileDirectory != null) this.fileDirectory = fileDirectory;
    if (serverLevel != null) this.serverLevel = serverLevel;
    if (serverUrl != null) this.serverUrl = serverUrl;
  }
}