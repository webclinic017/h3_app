//会员卡号类型

import 'package:h3_app/global.dart';

class MemberCardNoType {
  final String name;
  final String value;

  const MemberCardNoType._(this.name, this.value);

  //不打印
  static const None = MemberCardNoType._("未知", "0");

  static const CardNo = MemberCardNoType._("真实卡号", "1");
  static const Mobile = MemberCardNoType._("手机号", "2");
  static const ScanCode = MemberCardNoType._("电子卡号", "3");
  static const SurfaceNo = MemberCardNoType._("卡面号", "4");
  static const MemberNo = MemberCardNoType._("会员编号", "5");

  factory MemberCardNoType.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return MemberCardNoType.CardNo;
        }
      case "2":
        {
          return MemberCardNoType.Mobile;
        }
      case "3":
        {
          return MemberCardNoType.ScanCode;
        }
      case "4":
        {
          return MemberCardNoType.SurfaceNo;
        }
      case "5":
        {
          return MemberCardNoType.MemberNo;
        }
      default:
        {
          return MemberCardNoType.None;
        }
    }
  }

  factory MemberCardNoType.fromName(String name) {
    switch (name) {
      case "真实卡号":
        {
          return MemberCardNoType.CardNo;
        }
      case "手机号":
        {
          return MemberCardNoType.Mobile;
        }
      case "电子卡号":
        {
          return MemberCardNoType.ScanCode;
        }
      case "卡面号":
        {
          return MemberCardNoType.SurfaceNo;
        }
      case "会员编号":
        {
          return MemberCardNoType.MemberNo;
        }
      default:
        {
          return MemberCardNoType.None;
        }
    }
  }

  factory MemberCardNoType.judgeCardWay(String tenantId, String voucherNo) {
    MemberCardNoType type = MemberCardNoType.SurfaceNo;
    if (voucherNo != null) {
      if (voucherNo.length == 18) {
        //电子卡号
        var prefix = voucherNo.substring(0, 2);
        if (prefix == "99") {
          type = MemberCardNoType.ScanCode;
        }
      } else if (voucherNo.length == 11) {
        //手机卡号
        var prefix = voucherNo.substring(0, 2);
        if (prefix == "13" ||
            prefix == "14" ||
            prefix == "15" ||
            prefix == "16" ||
            prefix == "17" ||
            prefix == "18" ||
            prefix == "19") {
          type = MemberCardNoType.Mobile;
        }
      } else if (voucherNo.length == 16 &&
          voucherNo.startsWith(Global.instance.authc.tenantId)) {
        //巨为卡号
        var prefix = voucherNo.substring(0, 6);
        if (prefix == tenantId) {
          type = MemberCardNoType.CardNo;
        }
      } else {
        //无法识别，暂定为卡面号
        type = MemberCardNoType.SurfaceNo;

//    //根据开关判断默认识别卡面号还是会员编号
//    var judgeMemberNoEnable = Global.Instance.GlobalConfigBoolValue(ConfigConstant.JUDGE_MEMBER_NO_ENABLE, false);
//    if (judgeMemberNoEnable)
//    {
//    type = MemberCardNoType.会员编号;
//    }
//    else
//    {
//    //无法识别，暂定为卡面号
//    type = MemberCardNoType.FaceNo;
//    }
      }
    } else {
      type = MemberCardNoType.None;
    }
    return type;
  }
}
