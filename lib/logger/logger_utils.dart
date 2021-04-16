part of logger;

class LoggerUtils {
  static AnsiPen _ansiPen = AnsiPen();

  static AnsiPen getColor(LoggerLevel level) {
    switch (level) {
      case LoggerLevel.trace:
        return _ansiPen..blue();
      case LoggerLevel.debug:
        return _ansiPen..cyan();
      case LoggerLevel.info:
        return _ansiPen..gray();
      case LoggerLevel.warn:
        return _ansiPen..yellow();
      case LoggerLevel.error:
      case LoggerLevel.fatal:
        return _ansiPen..red();
      case LoggerLevel.off:
      default:
        return _ansiPen;
    }
  }

  static String getCurrentDateString() {
    DateTime date = DateTime.now();
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    return "$year$month$day";
  }

  static String enumToString(LoggerLevel type) {
    String typeString = type.toString();
    return typeString.split('.')[1].toUpperCase().padRight(5);
  }

  static LoggerLevel stringToEnum(String type) {
    return LoggerLevel.values.firstWhere((e) => e.toString() == type);
  }

  LoggerUtils._();
}
