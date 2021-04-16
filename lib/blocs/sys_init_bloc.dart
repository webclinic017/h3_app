import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/pos_authc.dart';
// import 'package:h3_app/entity/registration_code.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

class SysInitBloc extends Bloc<SysInitEvent, SysInitState> {
  SysInitRepository _sysInitRepository;

  SysInitBloc() : super(SysInitState.init()) {
    this._sysInitRepository = new SysInitRepository();
  }

  @override
  Stream<SysInitState> mapEventToState(SysInitEvent event) async* {
    if (event is LoadDataEvent) {
      yield* _mapLoadDataToState(event);
    } else if (event is SafeCodeChanged) {
      yield state.copyWith(
        safeCode: event.safeCode,
        safeCodeValid: _isSafeCodeValid(event.safeCode),
        status: SysInitStatus.Initial,
      );
    } else if (event is Submitted) {
      yield* _mapSubmittedToState();
    } else if (event is Successful) {
      yield* _mapSuccessfulToState();
    }
  }

  Stream<SysInitState> _mapSuccessfulToState() async* {
    try {
      yield state.waiting();

      Tuple2<bool, String> result =
          await this._sysInitRepository.clearAllData();

      if (result.item1) {
        yield state.success();
      } else {
        yield state.failure(
          message: result.item2,
        );
      }
    } catch (_) {
      yield state.failure(message: "激活码验证出错了");
    }
  }

  //加载数据
  Stream<SysInitState> _mapLoadDataToState(LoadDataEvent event) async* {
    try {
      var authc = await this._sysInitRepository.getAuthc();
      yield state.copyWith(
        authc: authc,
      );
    } catch (e, stack) {
      FLogger.error("加载销售流水异常:" + e.toString());
    }
  }

  Stream<SysInitState> _mapSubmittedToState() async* {
    yield state.loading();
    try {
      var currentDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyyMMdd");
      var tenantCode = state.authc == null ? "" : state.authc.tenantId;

      var result = StringUtils.isBlank(state.safeCode)
          ? false
          : state.safeCode == "$currentDate$tenantCode";
      if (result) {
        yield state.confirm();
      } else {
        yield state.failure(
          message: "安全码输入有误",
        );
      }
    } catch (_) {
      yield state.failure(message: "激活码验证出错");
    }
  }

  ///安全码输入验证，不为空，长度等于14
  bool _isSafeCodeValid(String safeCode) {
    return StringUtils.isNotBlank(safeCode) && safeCode.length == 14;
  }
}

//系统初始化事件
abstract class SysInitEvent extends Equatable {
  const SysInitEvent();
  @override
  List<Object> get props => [];
}

///加载数据
class LoadDataEvent extends SysInitEvent {}

///安全码输入事件
class SafeCodeChanged extends SysInitEvent {
  final String safeCode;
  final bool safeCodeValid;
  const SafeCodeChanged({
    this.safeCode,
    this.safeCodeValid,
  });

  @override
  List<Object> get props => [safeCode, safeCodeValid];
}

///提交事件
class Submitted extends SysInitEvent {}

///激活成功事件
class Successful extends SysInitEvent {}

enum SysInitStatus { Initial, Loading, Confirm, Waiting, Success, Failure }

//系统初始化状态
class SysInitState extends Equatable {
  //安全码
  final String safeCode;
  //激活码输入内容的校验
  final bool safeCodeValid;
  //加载遮罩层的通知
  final SysInitStatus status;
  //提示信息
  final String message;
  //注册登记信息
  final Authc authc;

  const SysInitState({
    this.safeCode,
    this.safeCodeValid,
    this.status,
    this.message,
    this.authc,
  });

  //初始化
  factory SysInitState.init() {
    return SysInitState(
      safeCode: "",
      safeCodeValid: false,
      status: SysInitStatus.Initial,
      message: "",
      authc: null,
    );
  }

  SysInitState loading() {
    return copyWith(
      status: SysInitStatus.Loading,
      message: "",
    );
  }

  SysInitState failure({String message}) {
    return copyWith(
      status: SysInitStatus.Failure,
      message: message,
    );
  }

  SysInitState confirm() {
    return copyWith(
      status: SysInitStatus.Confirm,
    );
  }

  SysInitState waiting() {
    return copyWith(
      status: SysInitStatus.Waiting,
    );
  }

  SysInitState success() {
    return copyWith(
      status: SysInitStatus.Success,
    );
  }

  SysInitState copyWith({
    String safeCode,
    bool safeCodeValid,
    SysInitStatus status,
    String message,
    Authc authc,
  }) {
    return SysInitState(
      safeCode: safeCode ?? this.safeCode,
      safeCodeValid: safeCodeValid ?? this.safeCodeValid,
      status: status ?? this.status,
      message: message ?? this.message,
      authc: authc ?? this.authc,
    );
  }

  bool get isValid => this.safeCodeValid;

  @override
  List<Object> get props => [
        this.safeCode,
        this.safeCodeValid,
        this.status,
        this.message,
        this.authc
      ];
}

class SysInitRepository {
  Future<Tuple2<bool, String>> clearAllData() async {
    bool result = false;
    String msg = "";

    try {
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        //删除pos_authc表数据
        await txn.rawDelete("delete from pos_authc;");
        //清理支付参数
        await txn.rawDelete("delete from pos_payment_parameter;");
        //清理充值支付参数
        await txn.rawDelete("delete from pos_payment_group_parameter;");
        //清理副屏多媒体内容设置
        //await txn.rawDelete("delete from pos_advert_media;");
        //清理副屏广告
        await txn.rawDelete("delete from pos_advert_picture;");
        //条码秤关联商品
        //await txn.rawDelete("delete from pos_barcode_scale_item_product;");
        //清理厨打方案
        await txn.rawDelete("delete from pos_kit_plan;");
        //清理厨显方案
        await txn.rawDelete("delete from pos_kds_plan;");
        //清理线上系统设置
        //await txn.rawDelete("delete from pos_line_system_set;");
        //清理小票图片
        await txn.rawDelete("delete from pos_print_img;");

        //清理订单主表信息
        await txn.rawDelete("delete from pos_order;");
        //清理订单商品明细表信息
        await txn.rawDelete("delete from pos_order_item;");
        //清理订单商品做法表信息
        await txn.rawDelete("delete from pos_order_item_make;");
        //清理订单商品优惠表信息
        await txn.rawDelete("delete from pos_order_item_promotion;");
        //清理订单优惠表信息
        await txn.rawDelete("delete from pos_order_promotion;");
        //清理订单支付表信息
        await txn.rawDelete("delete from pos_order_pay;");
        //清理kds表信息
        //await txn.rawDelete("delete from pos_order_item_kds;");
        //清理授权日志信息
        //await txn.rawDelete("delete from pos_log;");
        //清理耗料
        //await txn.rawDelete("delete from pos_material_consume;");
        //清理交班信息
        await txn.rawDelete("delete from pos_shift_log;");
        //await txn.rawDelete("delete from pos_shiftover_ticket;");
        //await txn.rawDelete("delete from pos_shiftover_ticket_cash;");
        //await txn.rawDelete("delete from pos_shiftover_ticket_pay;");
        //清理挂单信息
        //await txn.rawDelete("delete from pos_order_temp;");
        //清理核销记录
        await txn.rawDelete("delete from pos_online_pay_log;");
        //清理数据版本
        //await txn.rawDelete("delete from pos_data_version;");
        //清理卡充值订单
        //await txn.rawDelete("delete from pos_card_recharge_order;");
        //清理卡充值支付记录
        //await txn.rawDelete("delete from pos_card_recharge_order_pay;");
        //清理会员计次充值订单
        //await txn.rawDelete("delete from pos_member_times_recharge_order;");
        //清理会员计次充值支付记录
        //await txn.rawDelete("delete from pos_member_times_recharge_order_pay;");
        //清理寄存订单
        //await txn.rawDelete("delete from pos_deposit_order;");
        //清理热卖商品表
        //await txn.rawDelete("delete from pos_product_hotselling;");
      });

      result = true;
      msg = "系统初始化成功";
    } catch (e) {
      FLogger.error("系统初始化发生异常:" + e.toString());
      result = false;
      msg = "系统初始化发生异常";
    }
    return Tuple2<bool, String>(result, msg);
  }

  ///获取注册信息
  Future<Authc> getAuthc() async {
    Authc result;
    try {
      //获取系统唯一ID,做为判断依据
      var macAddress = Constants.VIRTUAL_MAC_ADDRESS;
      var diskSerialNumber = await DeviceUtils.instance.getSerialId();
      FLogger.debug(
          "本机硬件特征:MacAddress<$macAddress>,SerialId<$diskSerialNumber>");

      String sql =
          "select id,tenantId,compterName,macAddress,diskSerialNumber,cpuSerialNumber,storeId,storeNo,storeName,posId,posNo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_authc where diskSerialNumber='$diskSerialNumber' and macAddress = '$macAddress';";
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists.length > 0) {
        result = Authc.fromMap(lists.first);
      }
    } catch (e) {
      FLogger.error("获取设备注册信息异常:" + e.toString());
    }

    return result;
  }
}
