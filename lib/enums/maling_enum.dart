class MalingEnum {
  final String name;
  final int value;
  const MalingEnum._(this.name, this.value);

  static const None = MalingEnum._("不抹零", 0);

  static const MALING_1 = MalingEnum._("四舍五入到元", 1);

  static const MALING_2 = MalingEnum._("向下抹零到元", 2);

  static const MALING_3 = MalingEnum._("向上抹零到元", 3);

  static const MALING_4 = MalingEnum._("四舍五入到角", 4);

  static const MALING_5 = MalingEnum._("向下抹零到角", 5);

  static const MALING_6 = MalingEnum._("向上抹零到角", 6);

  static const MALING_7 = MalingEnum._("向下抹零到5角", 7);

  static const MALING_8 = MalingEnum._("向上抹零到5角", 8);

  static const MALING_9 = MalingEnum._("向下抹零到5元", 9);

  static const MALING_10 = MalingEnum._("向下抹零到10元", 10);

  static const MALING_11 = MalingEnum._("向下抹零到100元", 11);

  factory MalingEnum.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return MalingEnum.None;
        }
      case "1":
        {
          return MalingEnum.MALING_1;
        }
      case "2":
        {
          return MalingEnum.MALING_2;
        }
      case "3":
        {
          return MalingEnum.MALING_3;
        }
      case "4":
        {
          return MalingEnum.MALING_4;
        }
      case "5":
        {
          return MalingEnum.MALING_5;
        }
      case "6":
        {
          return MalingEnum.MALING_6;
        }
      case "7":
        {
          return MalingEnum.MALING_7;
        }
      case "8":
        {
          return MalingEnum.MALING_8;
        }
      case "9":
        {
          return MalingEnum.MALING_9;
        }
      case "10":
        {
          return MalingEnum.MALING_10;
        }
      case "11":
        {
          return MalingEnum.MALING_11;
        }
      default:
        {
          return MalingEnum.None;
        }
    }
  }

  factory MalingEnum.fromName(String name) {
    switch (name) {
      case "不抹零":
        {
          return MalingEnum.None;
        }
      case "四舍五入到元":
        {
          return MalingEnum.MALING_1;
        }
      case "向下抹零到元":
        {
          return MalingEnum.MALING_2;
        }
      case "向上抹零到元":
        {
          return MalingEnum.MALING_3;
        }
      case "四舍五入到角":
        {
          return MalingEnum.MALING_4;
        }
      case "向下抹零到角":
        {
          return MalingEnum.MALING_5;
        }
      case "向上抹零到角":
        {
          return MalingEnum.MALING_6;
        }
      case "向下抹零到5角":
        {
          return MalingEnum.MALING_7;
        }
      case "向上抹零到5角":
        {
          return MalingEnum.MALING_8;
        }
      case "向下抹零到5元":
        {
          return MalingEnum.MALING_9;
        }
      case "向下抹零到10元":
        {
          return MalingEnum.MALING_10;
        }
      case "向下抹零到100元":
        {
          return MalingEnum.MALING_11;
        }

      default:
        {
          return MalingEnum.None;
        }
    }
  }
}
