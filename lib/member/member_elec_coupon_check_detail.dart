import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class ElecCouponCheckDetail {
  /// 券ID
  String couponId = "";

  /// 实际用券金额
  double consumAmount = 0;

  ElecCouponCheckDetail();

  factory ElecCouponCheckDetail.fromJson(Map<String, dynamic> json) {
    return ElecCouponCheckDetail()
      ..couponId = Convert.toStr(json['couponId'])
      ..consumAmount = Convert.toDouble(json['consumAmount']);
  }

  static List<ElecCouponCheckDetail> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponCheckDetail>();
    lists.forEach((map) => result.add(ElecCouponCheckDetail.fromJson(map)));
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponId'] = this.couponId;
    data['consumAmount'] = this.consumAmount;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
