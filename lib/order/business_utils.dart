import 'package:h3_app/enums/module_key_code.dart';
import 'package:h3_app/enums/order_item_row_type.dart';
import 'package:h3_app/enums/order_row_status.dart';
import 'package:h3_app/enums/order_status_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/utils/tuple.dart';

import 'order_item.dart';
import 'order_object.dart';

class BusinessUtils {
// 工厂模式
  factory BusinessUtils() => _getInstance();

  static BusinessUtils get instance => _getInstance();
  static BusinessUtils _instance;

  static BusinessUtils _getInstance() {
    if (_instance == null) {
      _instance = new BusinessUtils._internal();
    }
    return _instance;
  }

  BusinessUtils._internal();

  Tuple2<bool, String> beforeMenuActionValidate(OrderObject orderObject,
      OrderItem orderItem, ModuleKeyCode moduleKeyCode) {
    // 第一步，菜单是否为操作当前订单，不是则放行，是则校验当前订单是否还允许操作
    var result =
        beforeOrderObjectValidateStep1(orderObject, orderItem, moduleKeyCode);
    if (result.item1) {
      result =
          beforeOrderObjectValidateStep2(orderObject, orderItem, moduleKeyCode);
    }

    return result;
  }

  //第一步，菜单是否为操作当前订单，不是则放行，是则校验当前订单是否还允许操作
  Tuple2<bool, String> beforeOrderObjectValidateStep1(OrderObject orderObject,
      OrderItem orderItem, ModuleKeyCode moduleKeyCode) {
    bool result = true;
    String message = "校验通过";

    //部分功能存在校验特例
    switch (moduleKeyCode) {
      case ModuleKeyCode.$_115: //会员$_109
        {
          if (!Global.instance.online) {
            message = "脱机状态暂不支持";
            result = false;
          } else {
            result = true;
          }
        }
        break;
      case ModuleKeyCode.$_109: //删除单品
        {
          if (!Global.instance.online) {
            message = "脱机状态暂不支持";
            result = false;
          } else {
            result = true;
          }
        }
        break;
      default:
        {
          if (result && orderObject == null) {
            result = false;
            message = "请取消订单后重新点单";
          }

          //订单交易完成，系统显示已结账,快速结账禁用
          if (result && (orderObject.orderStatus == OrderStatus.Completed)) {
            result = false;
            message = "不支持的操作,交易已结账";
          }

          //是否有点单记录存在
          if (result && orderObject.items.length == 0) {
            result = false;
            message = "请先点单";
          }

          //是否有选择的商品
          if (result && orderItem == null) {
            result = false;
            message = "请选择要操作的商品";
          }
        }
        break;
    }
    return Tuple2(result, message);
  }

  //第二步，菜单操作是否违反具体业务规则
  Tuple2<bool, String> beforeOrderObjectValidateStep2(OrderObject orderObject,
      OrderItem orderItem, ModuleKeyCode moduleKeyCode) {
    bool result = true;
    String message = "校验通过";

    return Tuple2(result, message);
  }

  ///桌台模式的菜单操作前的校验
  Tuple2<bool, String> beforeTableMenuActionValidate(OrderObject orderObject,
      OrderItem orderItem, ModuleKeyCode moduleKeyCode) {
    // 第一步，菜单是否为操作当前订单，不是则放行，是则校验当前订单是否还允许操作
    var result = beforeTableOrderObjectValidateStep1(
        orderObject, orderItem, moduleKeyCode);
    if (result.item1) {
      result = beforeTableOrderObjectValidateStep2(
          orderObject, orderItem, moduleKeyCode);
    }

    return result;
  }

  //第一步，菜单是否为操作当前订单，不是则放行，是则校验当前订单是否还允许操作
  Tuple2<bool, String> beforeTableOrderObjectValidateStep1(
      OrderObject orderObject,
      OrderItem orderItem,
      ModuleKeyCode moduleKeyCode) {
    bool result = true;
    String message = "校验通过";

    //部分功能存在校验特例
    switch (moduleKeyCode) {
      case ModuleKeyCode.$_115: //会员
        {
          if (!Global.instance.online) {
            message = "脱机状态暂不支持";
            result = false;
          } else {
            result = true;
          }
        }
        break;
      default:
        {
          if (result && orderObject == null) {
            result = false;
            message = "请取消订单后重新点单";
          }

          //订单交易完成，系统显示已结账,快速结账禁用
          if (result && (orderObject.orderStatus == OrderStatus.Completed)) {
            result = false;
            message = "不支持的操作,交易已结账";
          }

          //是否有点单记录存在
          if (result && orderObject.items.length == 0) {
            result = false;
            message = "请先点单";
          }

          //是否有选择的商品
          if (result && orderItem == null) {
            result = false;
            message = "请选择要操作的商品";
          }
        }
        break;
    }
    return Tuple2(result, message);
  }

  //第二步，菜单操作是否违反具体业务规则
  Tuple2<bool, String> beforeTableOrderObjectValidateStep2(
      OrderObject orderObject,
      OrderItem orderItem,
      ModuleKeyCode moduleKeyCode) {
    bool result = true;
    String message = "校验通过";

    switch (moduleKeyCode) {
      case ModuleKeyCode.$_104: //数量
      case ModuleKeyCode.$_105: //数量加
      case ModuleKeyCode.$_106: //数量减
        {
          if (result && orderItem.orderRowStatus == OrderRowStatus.Order) {
            message = "商品已下单不能修改数量";
            result = false;
          }
        }
        break;
      case ModuleKeyCode.$_109: //删除单品
        {
          if (result && orderItem.orderRowStatus == OrderRowStatus.Order) {
            message = "商品已下单不能删除";
            result = false;
          }
        }
        break;
      case ModuleKeyCode.$_110: //赠送
        {
          if (result && orderItem.rowType == OrderItemRowType.SuitDetail) {
            message = "不允许赠送套餐明细";
            result = false;
          }
        }
        break;
      case ModuleKeyCode.$_122: //退货
        {
          if (result && orderItem.rowType == OrderItemRowType.SuitDetail) {
            message = "不允许赠送套餐明细";
            result = false;
          }

          if (result &&
              (orderItem.orderRowStatus == OrderRowStatus.New ||
                  orderItem.orderRowStatus == OrderRowStatus.Save)) {
            message = "商品未下单,请直接删除";
            result = false;
          }
        }
        break;
      case ModuleKeyCode.$_111: //做法
        {
          //单据状态判断
          if (result && orderObject.orderStatus == OrderStatus.Completed ||
              orderObject.orderStatus == OrderStatus.ChargeBack) {
            result = false;
            message = "订单已结账";
          }

          if (result && orderItem.orderRowStatus == OrderRowStatus.Order) {
            message = "菜品已下单，不能修改做法";
            result = false;
          }

          //已经参与整单优惠，只能做结账相关动作
          if (result && orderObject.promotions.length > 0) {
            result = false;
            message = "已进行整单优惠，请进行结账";
          }

          //已经使用了代金券等支付方式，不能再操作订单
          if (result && orderObject.pays.length > 0) {
            result = false;
            message = "正在支付，请继续结账";
          }

          if (result && orderItem.rowType == OrderItemRowType.SuitMaster) {
            message = "只能对套餐明细设置做法";
            result = false;
          }
        }
        break;
    }
    return Tuple2(result, message);
  }
}
