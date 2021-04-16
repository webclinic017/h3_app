class PortTypeEnum {
  final String name;
  final String value;

  PortTypeEnum._(this.name, this.value);

  static final None = PortTypeEnum._("None", "0");
  static final SerialPort = PortTypeEnum._("串口", "1");
  static final ParallelPort = PortTypeEnum._("并口", "2");
  static final NetworkPort = PortTypeEnum._("网口", "3");
  static final UsbPort = PortTypeEnum._("USB", "4");
  static final DriveName = PortTypeEnum._("驱动", "5");

  factory PortTypeEnum.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return PortTypeEnum.SerialPort;
        }
      case "2":
        {
          return PortTypeEnum.ParallelPort;
        }
      case "3":
        {
          return PortTypeEnum.NetworkPort;
        }
      case "4":
        {
          return PortTypeEnum.UsbPort;
        }
      case "5":
        {
          return PortTypeEnum.DriveName;
        }
      default:
        {
          return PortTypeEnum.None;
        }
    }
  }

  factory PortTypeEnum.fromName(String name) {
    switch (name) {
      case "串口":
        {
          return PortTypeEnum.SerialPort;
        }
      case "并口":
        {
          return PortTypeEnum.ParallelPort;
        }
      case "网口":
        {
          return PortTypeEnum.NetworkPort;
        }
      case "USB":
        {
          return PortTypeEnum.UsbPort;
        }
      case "驱动":
        {
          return PortTypeEnum.DriveName;
        }
      default:
        {
          return PortTypeEnum.None;
        }
    }
  }
}
