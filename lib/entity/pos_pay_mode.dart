import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class PayMode extends BaseEntity {
  ///表名称
  static final String tableName = "pos_pay_mode";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnShortcut = "shortcut";
  static final String columnPointFlag = "pointFlag";
  static final String columnFrontFlag = "frontFlag";
  static final String columnBackFlag = "backFlag";
  static final String columnRechargeFlag = "rechargeFlag";
  static final String columnFaceMoney = "faceMoney";
  static final String columnPaidMoney = "paidMoney";
  static final String columnIncomeFlag = "incomeFlag";
  static final String columnOrderNo = "orderNo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnPlusFlag = "plusFlag";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,no,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag  from pos_pay_mode;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_pay_mode(id,tenantId,no,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.no,entity.name,entity.shortcut,entity.pointFlag,entity.frontFlag,entity.backFlag,entity.rechargeFlag,entity.faceMoney,entity.paidMoney,entity.incomeFlag,entity.orderNo,entity.ext1,entity.ext2,entity.ext3,entity.deleteFlag,entity.createDate,entity.createUser,entity.modifyDate,entity.modifyUser,entity.plusFlag ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_pay_mode set id= '%s',tenantId= '%s',no= '%s',name= '%s',shortcut= '%s',pointFlag= '%s',frontFlag= '%s',backFlag= '%s',rechargeFlag= '%s',faceMoney= '%s',paidMoney= '%s',incomeFlag= '%s',orderNo= '%s',ext1= '%s',ext2= '%s',ext3= '%s',deleteFlag= '%s',createDate= '%s',createUser= '%s',modifyDate= '%s',modifyUser= '%s',plusFlag= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.no,this.name,this.shortcut,this.pointFlag,this.frontFlag,this.backFlag,this.rechargeFlag,this.faceMoney,this.paidMoney,this.incomeFlag,this.orderNo,this.ext1,this.ext2,this.ext3,this.deleteFlag,this.createDate,this.createUser,this.modifyDate,this.modifyUser,this.plusFlag ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_pay_mode;"
  ///字段名称
  String no;
  String name;
  String shortcut;
  int pointFlag;
  int frontFlag;
  int backFlag;
  int rechargeFlag;
  double faceMoney;
  double paidMoney;
  int incomeFlag;
  int orderNo;
  int deleteFlag;
  int plusFlag;

  ///默认构造
  PayMode();

  ///Map转实体对象
  factory PayMode.fromMap(Map<String, dynamic> map) {
    return PayMode()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..shortcut = Convert.toStr(map[columnShortcut])
      ..pointFlag = Convert.toInt(map[columnPointFlag])
      ..frontFlag = Convert.toInt(map[columnFrontFlag])
      ..backFlag = Convert.toInt(map[columnBackFlag])
      ..rechargeFlag = Convert.toInt(map[columnRechargeFlag])
      ..faceMoney = Convert.toDouble(map[columnFaceMoney])
      ..paidMoney = Convert.toDouble(map[columnPaidMoney])
      ..incomeFlag = Convert.toInt(map[columnIncomeFlag])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..plusFlag = Convert.toInt(map[columnPlusFlag]);
  }

  ///构建空对象
  factory PayMode.newPayMode() {
    return PayMode()
      ..id = ""
      ..tenantId = ""
      ..no = ""
      ..name = ""
      ..shortcut = ""
      ..pointFlag = 0
      ..frontFlag = 0
      ..backFlag = 0
      ..rechargeFlag = 0
      ..faceMoney = 0
      ..paidMoney = 0
      ..incomeFlag = 0
      ..orderNo = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..deleteFlag = 0
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..modifyDate = ""
      ..modifyUser = ""
      ..plusFlag = 0;
  }

  ///复制新对象
  factory PayMode.clone(PayMode obj) {
    return PayMode()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..no = obj.no
      ..name = obj.name
      ..shortcut = obj.shortcut
      ..pointFlag = obj.pointFlag
      ..frontFlag = obj.frontFlag
      ..backFlag = obj.backFlag
      ..rechargeFlag = obj.rechargeFlag
      ..faceMoney = obj.faceMoney
      ..paidMoney = obj.paidMoney
      ..incomeFlag = obj.incomeFlag
      ..orderNo = obj.orderNo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..deleteFlag = obj.deleteFlag
      ..createDate = obj.createDate
      ..createUser = obj.createUser
      ..modifyDate = obj.modifyDate
      ..modifyUser = obj.modifyUser
      ..plusFlag = obj.plusFlag;
  }

  ///转List集合
  static List<PayMode> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PayMode>();
    lists.forEach((map) => result.add(PayMode.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnName: this.name,
      columnShortcut: this.shortcut,
      columnPointFlag: this.pointFlag,
      columnFrontFlag: this.frontFlag,
      columnBackFlag: this.backFlag,
      columnRechargeFlag: this.rechargeFlag,
      columnFaceMoney: this.faceMoney,
      columnPaidMoney: this.paidMoney,
      columnIncomeFlag: this.incomeFlag,
      columnOrderNo: this.orderNo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnDeleteFlag: this.deleteFlag,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyDate: this.modifyDate,
      columnModifyUser: this.modifyUser,
      columnPlusFlag: this.plusFlag,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }

  ///重写
  @override
  List<Object> get props => [
        id,
        tenantId,
        no,
        name,
        shortcut,
        pointFlag,
        frontFlag,
        backFlag,
        rechargeFlag,
        faceMoney,
        paidMoney,
        incomeFlag,
        orderNo,
        ext1,
        ext2,
        ext3,
        deleteFlag,
        createDate,
        createUser,
        modifyDate,
        modifyUser,
        plusFlag,
      ];
}
