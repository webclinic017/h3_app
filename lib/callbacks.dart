import 'package:h3_app/entity/pos_product_spec.dart';
import 'package:h3_app/entity/pos_store_table.dart';
import 'package:h3_app/order/order_pay.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/utils/tuple.dart';

import 'entity/pos_worker.dart';
import 'member/member.dart';
import 'order/order_item.dart';
import 'order/order_item_make.dart';
import 'order/order_object.dart';
import 'order/order_table.dart';

typedef VoidCallback = void Function();

///关闭
typedef OnCloseCallback = void Function();

///确定
typedef OnAcceptCallback = void Function(AcceptArgs agrs);

///取消
typedef OnCancelCallback = void Function(AcceptArgs agrs);

///更换
typedef OnChangedCallback = void Function(AcceptArgs agrs);

///授权
typedef PermissionAction = void Function(
    Tuple4<double, double, List<String>, Worker>);

///扫码支付回调
typedef OnPaymentCallback = void Function(
    OrderObject orderObject, ScanPayResult payResult);

abstract class AcceptArgs {}

class EmptyArgs extends AcceptArgs {}

//会员回调参数
class MemberArgs extends AcceptArgs {
  final OrderObject orderObject;

  MemberArgs(this.orderObject);

  @override
  String toString() {
    return "{'orderObject':${orderObject.toString()}";
  }
}

//支付回调参数
class OrderPayArgs extends AcceptArgs {
  final OrderPay orderPay;

  OrderPayArgs(this.orderPay);

  @override
  String toString() {
    return "{'orderPay':${orderPay.toString()}";
  }
}

//数量回调参数
class QuantityArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double inputValue;

  QuantityArgs(this.orderItem, this.inputValue);

  @override
  String toString() {
    return "{'orderItem':${orderItem.toString()},'inputValue':$inputValue}";
  }
}

//赠送回调参数
class GiftArgs extends AcceptArgs {
  final OrderItem orderItem;
  final String reason;

  GiftArgs(this.orderItem, this.reason);

  @override
  String toString() {
    return "{'reason':$reason,'orderItem':${orderItem.toString()}}";
  }
}

//议价回调参数
class BargainArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double inputValue;
  final String reason;
  final bool restoreOriginalPrice;
  BargainArgs(this.orderItem, this.inputValue, this.reason,
      {this.restoreOriginalPrice = false});

  @override
  String toString() {
    return "{'inputValue':$inputValue,'reason':$reason,'restoreOriginalPrice':$restoreOriginalPrice,'orderItem':${orderItem.toString()}}";
  }
}

//折扣回调参数
class DiscountArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double inputValue;
  final String reason;
  final bool restoreOriginalPrice;
  DiscountArgs(this.orderItem, this.inputValue, this.reason,
      {this.restoreOriginalPrice = false});

  @override
  String toString() {
    return "{'inputValue':$inputValue,'reason':$reason,'restoreOriginalPrice':$restoreOriginalPrice},'orderItem':${orderItem.toString()}";
  }
}

//零价商品回调参数
class InputPriceArgs extends AcceptArgs {
  final double inputValue;

  InputPriceArgs(this.inputValue);

  @override
  String toString() {
    return "{'inputValue':$inputValue}";
  }
}

//称重商品输入数量回调参数
class InputQuantityArgs extends AcceptArgs {
  final double inputValue;

  InputQuantityArgs(this.inputValue);

  @override
  String toString() {
    return "{'inputValue':$inputValue}";
  }
}

class ProductSpecArgs extends AcceptArgs {
  final ProductSpec productSpec;
  final List<OrderItemMake> makeList;
  final double inputQuantity;
  ProductSpecArgs(this.productSpec, this.makeList, this.inputQuantity);

  @override
  String toString() {
    return "{'ProductSpec':$ProductSpec}";
  }
}

class RefundOrderObjectArgs extends AcceptArgs {
  final OrderObject refundOrderObject;
  RefundOrderObjectArgs(this.refundOrderObject);

  @override
  String toString() {
    return "{'refundOrderObject':$refundOrderObject}";
  }
}

//数据下载参数
class FastDownloadArgs extends AcceptArgs {
  FastDownloadArgs();
}

//开台参数
class OpenTableArgs extends AcceptArgs {
  final bool toDish;
  final OrderTable orderTable;

  OpenTableArgs({this.orderTable, this.toDish = false});

  @override
  String toString() {
    return "{'toDish':$toDish}";
  }
}

//转台参数
class TransferTableArgs extends AcceptArgs {
  final OrderObject orderObject;
  final StoreTable targetTable;
  TransferTableArgs({this.orderObject, this.targetTable});

  @override
  String toString() {
    return "{'orderObject':'$orderObject','targetTable':'$targetTable'}";
  }
}

///并台点单的参数
class MergeCashierArgs extends AcceptArgs {
  //单桌点单，否则是多桌点单
  final bool onlySelectedTable;

  MergeCashierArgs({this.onlySelectedTable = true});

  @override
  String toString() {
    return "{'onlySelectedTable':$onlySelectedTable}";
  }
}

class ProductSpecAndMakeArgs extends AcceptArgs {
  final ProductSpec productSpec;
  final List<OrderItemMake> makeList;
  final double inputQuantity;
  ProductSpecAndMakeArgs(this.productSpec, this.makeList, this.inputQuantity);

  @override
  String toString() {
    return "{'ProductSpec':$ProductSpec}";
  }
}

//桌台支付回调参数
class TableOrderPayArgs extends AcceptArgs {
  final OrderPay orderPay;

  TableOrderPayArgs(this.orderPay);

  @override
  String toString() {
    return "{'orderPay':${orderPay.toString()}";
  }
}

//桌台数量回调参数
class TableQuantityArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double inputValue;

  TableQuantityArgs(this.orderItem, this.inputValue);

  @override
  String toString() {
    return "{'orderItem':${orderItem.toString()},'inputValue':$inputValue}";
  }
}

//桌台赠送回调参数
class TableGiftArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double giftQuantity;
  final String giftReason;
  final bool cancelGift;
  TableGiftArgs(this.orderItem, this.giftQuantity, this.giftReason,
      {this.cancelGift = false});

  @override
  String toString() {
    return "{'quantity':'$giftQuantity','reason':$giftReason,'orderItem':${orderItem.toString()}},'cancelGift':$cancelGift";
  }
}

//桌台退菜回调参数
class TableRefundQuantityArgs extends AcceptArgs {
  final OrderItem orderItem;
  final double refundQuantity;
  final String refundReason;

  TableRefundQuantityArgs(
      this.orderItem, this.refundQuantity, this.refundReason);

  @override
  String toString() {
    return "{'quantity':'$refundQuantity','reason':$refundReason,'orderItem':${orderItem.toString()}}";
  }
}

//桌台整单议价回调参数
class TableBargainArgs extends AcceptArgs {
  final OrderObject orderObject;
  final double inputAmount;
  final String bargainReason;
  final bool restoreOriginalPrice;
  TableBargainArgs(this.orderObject, this.inputAmount, this.bargainReason,
      {this.restoreOriginalPrice = false});

  @override
  String toString() {
    return "{'inputAmount':$inputAmount,'reason':$bargainReason,'restoreOriginalPrice':$restoreOriginalPrice,'orderObject':${orderObject.toString()}}";
  }
}

//桌台整单折扣回调参数
class TableDiscountArgs extends AcceptArgs {
  final OrderObject orderObject;
  final double discountRate;
  final String discountReason;
  final bool restoreOriginalPrice;
  TableDiscountArgs(this.orderObject, this.discountRate, this.discountReason,
      {this.restoreOriginalPrice = false});

  @override
  String toString() {
    return "{'discountRate':$discountRate,'discountReason':$discountReason,'restoreOriginalPrice':$restoreOriginalPrice},'orderObject':${orderObject.toString()}";
  }
}

//桌台会员回调参数
class TableMemberArgs extends AcceptArgs {
  final Member member;

  TableMemberArgs(this.member);

  @override
  String toString() {
    return "{'member':${member.toString()}";
  }
}

//点菜宝参数
class AssistantOpenArgs extends AcceptArgs {
  final OrderObject orderObject;
  final String tableId;

  final bool toDish;

  AssistantOpenArgs({this.orderObject, this.tableId, this.toDish = false});

  @override
  String toString() {
    return "{'orderObject':$orderObject,'tableId':$tableId,'toDish':$toDish}";
  }
}
