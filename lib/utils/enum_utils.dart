class EnumUtils {
  static String parse(enumItem) {
    if (enumItem == null) return null;
    return enumItem.toString().split('.')[1];
  }

  static fromString<T>(List<T> enumValues, String value) {
    if (value == null) return null;

    return enumValues.singleWhere(
        (enumItem) => EnumUtils.parse(enumItem) == value,
        orElse: () => null);
  }
}
