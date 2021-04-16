class DynamicLibraryEnum {
  final String name;
  final String value;

  DynamicLibraryEnum._(this.name, this.value);

  static final Common = DynamicLibraryEnum._("通用打印模式", "0");

  static final SNBC = DynamicLibraryEnum._("北洋打印机专用", "1");

  factory DynamicLibraryEnum.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return DynamicLibraryEnum.SNBC;
        }
      default:
        {
          return DynamicLibraryEnum.Common;
        }
    }
  }

  factory DynamicLibraryEnum.fromName(String name) {
    switch (name) {
      case "北洋打印机专用":
        {
          return DynamicLibraryEnum.SNBC;
        }
      default:
        {
          return DynamicLibraryEnum.Common;
        }
    }
  }
}
