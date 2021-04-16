import 'dart:convert';

class Convert {
  static int toInt(dynamic item) => (item != null && item != 'null')
      ? item.runtimeType == int
          ? item
          : int.parse(item.toString())
      : null;

  static double toDouble(dynamic item) => (item != null && item != 'null')
      ? item.runtimeType == double
          ? item
          : double.parse(item.toString())
      : null;

  static DateTime toDateTime(dynamic item) => (item != null && item != 'null')
      ? item.runtimeType == DateTime
          ? item
          : DateTime.parse(item)
      : null;

  static bool toBool(dynamic item) => (item != null && item != 'null')
      ? item.runtimeType == bool
          ? item
          : (item == 'true' ? true : false)
      : null;

  static List<String> toList(List<dynamic> input) => input != null
      ? input.map((dynamic item) => item.toString()).toList()
      : null;

  static String toStr(dynamic value, [String defaultValue]) {
    String result = defaultValue;

    if (value != null) {
      if ((value is String) || (value is int) || (value is double)) {
        result = value.toString();
      } else if ((value is Map) ?? (value is List)) {
        result = json.encode(value);
      } else {
        result = value;
      }
    }

    if (result != null) {
      result = result.replaceAll("'", "''");
    }

    return result;
  }
}
