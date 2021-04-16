import 'package:h3_app/utils/string_utils.dart';

///已经适配的打印机清单
class PrinterConstant {
  static Map<String, List<String>> dataSource = {
    "商米": ["T1", "T2"],
    "联迪": ["C7", "C7Lite", "C9", "C10"],
    "天波": ["TPS650T"],
  };

  ///构建打印机品牌字符串
  static String getPrinterBrands() {
    String result = "";
    dataSource.forEach((key, value) {
      if (StringUtils.isNotBlank(result)) {
        result += ",$key";
      } else {
        result = "$key";
      }
    });
    return result;
  }

  ///构建打印机品牌字符串
  static List<String> getPrinter(String brandName) {
    List<String> result = <String>[];
    if (dataSource.containsKey(brandName)) {
      result.addAll(dataSource[brandName]);
    }
    return result;
  }
}

//打印机用途
class PrinterTicketEunm {
  final String name;
  final String value;

  PrinterTicketEunm._(this.name, this.value);

  //收银小票
  static final CashierTicket = PrinterTicketEunm._("前台小票", "0");

  //厨房小票
  static final KitchenTicket = PrinterTicketEunm._("后厨小票", "1");

  //外出品小票
  static final ProductTicket = PrinterTicketEunm._("出品小票", "2");

  //标签
  static final LabelTicket = PrinterTicketEunm._("标签", "3");

  static Map<int, PrinterTicketEunm> getValues() {
    Map<int, PrinterTicketEunm> result = {
      0: CashierTicket,
      1: KitchenTicket,
      2: ProductTicket,
      3: LabelTicket,
    };
    return result;
  }

  static int getIndex(String name) {
    return PrinterTicketEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterTicketEunm.getValues()[key]) ==
            PrinterTicketEunm.fromName("$name"),
        orElse: () => 0);
  }

  factory PrinterTicketEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterTicketEunm.CashierTicket;
        }
      case "1":
        {
          return PrinterTicketEunm.KitchenTicket;
        }
      case "2":
        {
          return PrinterTicketEunm.ProductTicket;
        }
      case "3":
        {
          return PrinterTicketEunm.LabelTicket;
        }
      default:
        {
          return PrinterTicketEunm.CashierTicket;
        }
    }
  }

  factory PrinterTicketEunm.fromName(String name) {
    switch (name) {
      case "前台小票":
        {
          return PrinterTicketEunm.CashierTicket;
        }
      case "后厨小票":
        {
          return PrinterTicketEunm.KitchenTicket;
        }
      case "出品小票":
        {
          return PrinterTicketEunm.ProductTicket;
        }
      case "标签":
        {
          return PrinterTicketEunm.LabelTicket;
        }

      default:
        {
          return PrinterTicketEunm.CashierTicket;
        }
    }
  }
}

//打印机型号
class PrinterModelEunm {
  final String name;
  final String value;

  const PrinterModelEunm._(this.name, this.value);

  //外置打印机
  static const Normal = PrinterModelEunm._("外置打印机", "0");

  //内置打印机
  static const Embed = PrinterModelEunm._("内置打印机", "1");

  static Map<int, PrinterModelEunm> getValues() {
    Map<int, PrinterModelEunm> result = {
      0: Normal,
      1: Embed,
    };
    return result;
  }

  static int getIndex(String name) {
    return PrinterModelEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterModelEunm.getValues()[key]) ==
            PrinterModelEunm.fromName("$name"),
        orElse: () => 0);
  }

  factory PrinterModelEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterModelEunm.Normal;
        }
      case "1":
        {
          return PrinterModelEunm.Embed;
        }

      default:
        {
          return PrinterModelEunm.Normal;
        }
    }
  }

  factory PrinterModelEunm.fromName(String name) {
    switch (name) {
      case "外置打印机":
        {
          return PrinterModelEunm.Normal;
        }
      case "内置打印机":
        {
          return PrinterModelEunm.Embed;
        }
      default:
        {
          return PrinterModelEunm.Normal;
        }
    }
  }
}

//打印机端口
class PrinterPortEunm {
  final String name;
  final String value;

  const PrinterPortEunm._(this.name, this.value);

  //网口
  static const Network = PrinterPortEunm._("网口", "0");

  //蓝牙
  static const Bluetooth = PrinterPortEunm._("蓝牙", "1");

  static Map<int, PrinterPortEunm> getValues() {
    Map<int, PrinterPortEunm> result = {
      0: Network,
      1: Bluetooth,
    };
    return result;
  }

  static int getIndex(String name) {
    return PrinterPortEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterPortEunm.getValues()[key]) ==
            PrinterPortEunm.fromName("$name"),
        orElse: () => 0);
  }

  factory PrinterPortEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterPortEunm.Network;
        }
      case "1":
        {
          return PrinterPortEunm.Bluetooth;
        }

      default:
        {
          return PrinterPortEunm.Network;
        }
    }
  }

  factory PrinterPortEunm.fromName(String name) {
    switch (name) {
      case "网口":
        {
          return PrinterPortEunm.Network;
        }
      case "蓝牙":
        {
          return PrinterPortEunm.Bluetooth;
        }
      default:
        {
          return PrinterPortEunm.Network;
        }
    }
  }
}

//内置打印机清单
class PrinterEmbedEunm {
  final String name;
  final String value;

  const PrinterEmbedEunm._(this.name, this.value);

  //SUNMI V1
  static const SunmiV1 = PrinterEmbedEunm._("商米V1", "0");

  //SUNMI V2
  static const SunmiV2 = PrinterEmbedEunm._("商米V2", "1");

  // //Landi C7
  // static final LandiC7 = PrinterEmbedEunm._("联迪C7", "2");
  // //Landi C7Lite
  // static final LandiC7Lite = PrinterEmbedEunm._("联迪C7Lite", "3");
  // //Landi C9
  // static final C9 = PrinterEmbedEunm._("联迪C9", "4");
  // //Landi C10
  // static final C10 = PrinterEmbedEunm._("联迪C10", "5");

  static Map<int, PrinterEmbedEunm> getValues() {
    Map<int, PrinterEmbedEunm> result = {
      0: SunmiV1,
      1: SunmiV2,
      // 2: LandiC7,
      // 3: LandiC7Lite,
      // 4: C9,
      // 5: C10,
    };

    return result;
  }

  static int getIndex(String name) {
    return PrinterEmbedEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterEmbedEunm.getValues()[key]) ==
            PrinterEmbedEunm.fromName("$name"),
        orElse: () => 0);
  }

  factory PrinterEmbedEunm.fromName(String name) {
    switch (name) {
      case "商米V1":
        {
          return PrinterEmbedEunm.SunmiV1;
        }
      case "商米V2":
        {
          return PrinterEmbedEunm.SunmiV2;
        }
      default:
        {
          return PrinterEmbedEunm.SunmiV1;
        }
    }
  }
}

//打印纸张
class PrinterPagerEunm {
  final String name;
  final String value;

  PrinterPagerEunm._(this.name, this.value);

  //网口
  static final M58MM = PrinterPagerEunm._("58纸", "58");

  //蓝牙
  static final M80MM = PrinterPagerEunm._("80纸", "80");

  static Map<int, PrinterPagerEunm> getValues() {
    Map<int, PrinterPagerEunm> result = {
      0: M58MM,
      1: M80MM,
    };
    return result;
  }

  static int getIndex(String value) {
    return PrinterPagerEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterPagerEunm.getValues()[key]) ==
            PrinterPagerEunm.fromValue("$value"),
        orElse: () => 0);
  }

  factory PrinterPagerEunm.fromValue(String value) {
    switch (value) {
      case "58":
        {
          return PrinterPagerEunm.M58MM;
        }
      case "80":
        {
          return PrinterPagerEunm.M80MM;
        }

      default:
        {
          return PrinterPagerEunm.M58MM;
        }
    }
  }

  factory PrinterPagerEunm.fromName(String name) {
    switch (name) {
      case "58纸":
        {
          return PrinterPagerEunm.M58MM;
        }
      case "80纸":
        {
          return PrinterPagerEunm.M80MM;
        }
      default:
        {
          return PrinterPagerEunm.M58MM;
        }
    }
  }
}

//打印切纸
class PrinterCutEunm {
  final String name;
  final String value;

  PrinterCutEunm._(this.name, this.value);

  //不切纸
  static final NoCut = PrinterCutEunm._("不切", "0");

  //半切纸
  static final HalfCut = PrinterCutEunm._("半切", "1");

  //全切纸
  static final AllCut = PrinterCutEunm._("全切", "2");

  static Map<int, PrinterCutEunm> getValues() {
    Map<int, PrinterCutEunm> result = {
      0: NoCut,
      1: HalfCut,
      2: AllCut,
    };
    return result;
  }

  static int getIndex(String name) {
    return PrinterCutEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterCutEunm.getValues()[key]) ==
            PrinterCutEunm.fromName("$name"),
        orElse: () => 0);
  }

  factory PrinterCutEunm.fromName(String name) {
    switch (name) {
      case "不切":
        {
          return PrinterCutEunm.NoCut;
        }
      case "半切":
        {
          return PrinterCutEunm.HalfCut;
        }
      case "全切":
        {
          return PrinterCutEunm.AllCut;
        }
      default:
        {
          return PrinterCutEunm.NoCut;
        }
    }
  }

  factory PrinterCutEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterCutEunm.NoCut;
        }
      case "1":
        {
          return PrinterCutEunm.HalfCut;
        }
      case "2":
        {
          return PrinterCutEunm.AllCut;
        }
      default:
        {
          return PrinterCutEunm.NoCut;
        }
    }
  }
}

//打印条码
class PrinterBarcodeEunm {
  final String name;
  final String value;

  PrinterBarcodeEunm._(this.name, this.value);

  //不打条码
  static final No = PrinterBarcodeEunm._("不打条码", "0");

  //打印条码
  static final Yes = PrinterBarcodeEunm._("打印条码", "1");

  static Map<int, PrinterBarcodeEunm> getValues() {
    Map<int, PrinterBarcodeEunm> result = {
      0: No,
      1: Yes,
    };
    return result;
  }

  static int getIndex(String value) {
    return PrinterBarcodeEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterBarcodeEunm.getValues()[key]) ==
            PrinterBarcodeEunm.fromValue("$value"),
        orElse: () => 0);
  }

  factory PrinterBarcodeEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterBarcodeEunm.No;
        }
      case "1":
        {
          return PrinterBarcodeEunm.Yes;
        }

      default:
        {
          return PrinterBarcodeEunm.No;
        }
    }
  }

  factory PrinterBarcodeEunm.fromName(String name) {
    switch (name) {
      case "不打条码":
        {
          return PrinterBarcodeEunm.No;
        }
      case "打印条码":
        {
          return PrinterBarcodeEunm.Yes;
        }
      default:
        {
          return PrinterBarcodeEunm.Yes;
        }
    }
  }
}

//打印二维码
class PrinterQRCodeEunm {
  final String name;
  final String value;

  PrinterQRCodeEunm._(this.name, this.value);

  //不打二维码
  static final No = PrinterQRCodeEunm._("不打二维码", "0");

  //打印二维码
  static final Yes = PrinterQRCodeEunm._("打印二维码", "1");

  static Map<int, PrinterQRCodeEunm> getValues() {
    Map<int, PrinterQRCodeEunm> result = {
      0: No,
      1: Yes,
    };
    return result;
  }

  static int getIndex(String value) {
    return PrinterQRCodeEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterQRCodeEunm.getValues()[key]) ==
            PrinterQRCodeEunm.fromValue("$value"),
        orElse: () => 0);
  }

  factory PrinterQRCodeEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterQRCodeEunm.No;
        }
      case "1":
        {
          return PrinterQRCodeEunm.Yes;
        }

      default:
        {
          return PrinterQRCodeEunm.No;
        }
    }
  }

  factory PrinterQRCodeEunm.fromName(String name) {
    switch (name) {
      case "不打二维码":
        {
          return PrinterQRCodeEunm.No;
        }
      case "打印二维码":
        {
          return PrinterQRCodeEunm.Yes;
        }
      default:
        {
          return PrinterQRCodeEunm.Yes;
        }
    }
  }
}

//打印头部空白行
class PrinterHeaderLineEunm {
  final String name;
  final String value;

  PrinterHeaderLineEunm._(this.name, this.value);

  //0行
  static final Zero = PrinterHeaderLineEunm._("顶留空", "0");

  //1行
  static final One = PrinterHeaderLineEunm._("1", "1");

  //2行
  static final Two = PrinterHeaderLineEunm._("2", "2");

  //3行
  static final Three = PrinterHeaderLineEunm._("3", "3");

  //4行
  static final Four = PrinterHeaderLineEunm._("4", "4");

  //5行
  static final Five = PrinterHeaderLineEunm._("5", "5");

  //6行
  static final Six = PrinterHeaderLineEunm._("6行", "6");

  static Map<int, PrinterHeaderLineEunm> getValues() {
    Map<int, PrinterHeaderLineEunm> result = {
      0: Zero,
      1: One,
      2: Two,
      3: Three,
      4: Four,
      5: Five,
      6: Six,
    };
    return result;
  }

  static int getIndex(String value) {
    return PrinterHeaderLineEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterHeaderLineEunm.getValues()[key]) ==
            PrinterHeaderLineEunm.fromValue("$value"),
        orElse: () => 0);
  }

  factory PrinterHeaderLineEunm.fromName(String name) {
    switch (name) {
      case "顶留空":
        {
          return PrinterHeaderLineEunm.Zero;
        }
      case "1":
        {
          return PrinterHeaderLineEunm.One;
        }
      case "2":
        {
          return PrinterHeaderLineEunm.Two;
        }
      case "3":
        {
          return PrinterHeaderLineEunm.Three;
        }
      case "4":
        {
          return PrinterHeaderLineEunm.Four;
        }
      case "5":
        {
          return PrinterHeaderLineEunm.Five;
        }
      case "6行":
        {
          return PrinterHeaderLineEunm.Six;
        }
      default:
        {
          return PrinterHeaderLineEunm.Zero;
        }
    }
  }

  factory PrinterHeaderLineEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterHeaderLineEunm.Zero;
        }
      case "1":
        {
          return PrinterHeaderLineEunm.One;
        }
      case "2":
        {
          return PrinterHeaderLineEunm.Two;
        }
      case "3":
        {
          return PrinterHeaderLineEunm.Three;
        }
      case "4":
        {
          return PrinterHeaderLineEunm.Four;
        }
      case "5":
        {
          return PrinterHeaderLineEunm.Five;
        }
      case "6":
        {
          return PrinterHeaderLineEunm.Six;
        }
      default:
        {
          return PrinterHeaderLineEunm.Zero;
        }
    }
  }
}

//打印底部空白行
class PrinterFooterLineEunm {
  final String name;
  final String value;

  PrinterFooterLineEunm._(this.name, this.value);

  //0行
  static final Zero = PrinterFooterLineEunm._("底留空", "0");

  //1行
  static final One = PrinterFooterLineEunm._("1", "1");

  //2行
  static final Two = PrinterFooterLineEunm._("2", "2");

  //3行
  static final Three = PrinterFooterLineEunm._("3", "3");

  //4行
  static final Four = PrinterFooterLineEunm._("4", "4");

  //5行
  static final Five = PrinterFooterLineEunm._("5", "5");

  //6行
  static final Six = PrinterFooterLineEunm._("6行", "6");

  static Map<int, PrinterFooterLineEunm> getValues() {
    Map<int, PrinterFooterLineEunm> result = {
      0: Zero,
      1: One,
      2: Two,
      3: Three,
      4: Four,
      5: Five,
      6: Six,
    };
    return result;
  }

  static int getIndex(String value) {
    return PrinterFooterLineEunm.getValues().keys.firstWhere(
        (key) =>
            (PrinterFooterLineEunm.getValues()[key]) ==
            PrinterFooterLineEunm.fromValue("$value"),
        orElse: () => 0);
  }

  factory PrinterFooterLineEunm.fromName(String name) {
    switch (name) {
      case "底留空":
        {
          return PrinterFooterLineEunm.Zero;
        }
      case "1":
        {
          return PrinterFooterLineEunm.One;
        }
      case "2":
        {
          return PrinterFooterLineEunm.Two;
        }
      case "3":
        {
          return PrinterFooterLineEunm.Three;
        }
      case "4":
        {
          return PrinterFooterLineEunm.Four;
        }
      case "5":
        {
          return PrinterFooterLineEunm.Five;
        }
      case "6行":
        {
          return PrinterFooterLineEunm.Six;
        }
      default:
        {
          return PrinterFooterLineEunm.Zero;
        }
    }
  }

  factory PrinterFooterLineEunm.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PrinterFooterLineEunm.Zero;
        }
      case "1":
        {
          return PrinterFooterLineEunm.One;
        }
      case "2":
        {
          return PrinterFooterLineEunm.Two;
        }
      case "3":
        {
          return PrinterFooterLineEunm.Three;
        }
      case "4":
        {
          return PrinterFooterLineEunm.Four;
        }
      case "5":
        {
          return PrinterFooterLineEunm.Five;
        }
      case "6":
        {
          return PrinterFooterLineEunm.Six;
        }
      default:
        {
          return PrinterFooterLineEunm.Zero;
        }
    }
  }
}
