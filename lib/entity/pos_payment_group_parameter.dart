import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class PaymentGroupParameter extends BaseEntity {
  ///表名称
  static final String tableName = "pos_payment_group_parameter";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnGroupId = "groupId";
  static final String columnGroupNo = "groupNo";
  static final String columnNo = "no";
  static final String columnStoreId = "storeId";
  static final String columnSign = "sign";
  static final String columnPbody = "pbody";
  static final String columnEnabled = "enabled";
  static final String columnCertText = "certText";
  static final String columnLocalFlag = "localFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,groupId,groupNo,no,storeId,sign,pbody,enabled,certText,localFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_payment_group_parameter;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_payment_group_parameter(id,tenantId,groupId,groupNo,no,storeId,sign,pbody,enabled,certText,localFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[this.id,this.tenantId,this.groupId,this.groupNo,this.no,this.storeId,this.sign,this.pbody,this.enabled,this.certText,this.localFlag,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_payment_group_parameter set id= '%s',tenantId= '%s',groupId= '%s',groupNo= '%s',no= '%s',storeId= '%s',sign= '%s',pbody= '%s',enabled= '%s',certText= '%s',localFlag= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.groupId,this.groupNo,this.no,this.storeId,this.sign,this.pbody,this.enabled,this.certText,this.localFlag,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_payment_group_parameter;"
  ///字段名称
  String groupId;
  String groupNo;
  String no;
  String storeId;
  String sign;
  String pbody;
  int enabled;
  String certText;
  int localFlag;

  ///默认构造
  PaymentGroupParameter();

  ///Map转实体对象
  factory PaymentGroupParameter.fromMap(Map<String, dynamic> map) {
    return PaymentGroupParameter()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..groupId = Convert.toStr(map[columnGroupId])
      ..groupNo = Convert.toStr(map[columnGroupNo])
      ..no = Convert.toStr(map[columnNo])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..sign = Convert.toStr(map[columnSign])
      ..pbody = Convert.toStr(map[columnPbody])
      ..enabled = Convert.toInt(map[columnEnabled])
      ..certText = Convert.toStr(map[columnCertText])
      ..localFlag = Convert.toInt(map[columnLocalFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory PaymentGroupParameter.newPaymentGroupParameter() {
    return PaymentGroupParameter()
      ..id = ""
      ..tenantId = ""
      ..groupId = ""
      ..groupNo = ""
      ..no = ""
      ..storeId = ""
      ..sign = ""
      ..pbody = ""
      ..enabled = 0
      ..certText = ""
      ..localFlag = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory PaymentGroupParameter.clone(PaymentGroupParameter obj) {
    return PaymentGroupParameter()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..groupId = obj.groupId
      ..groupNo = obj.groupNo
      ..no = obj.no
      ..storeId = obj.storeId
      ..sign = obj.sign
      ..pbody = obj.pbody
      ..enabled = obj.enabled
      ..certText = obj.certText
      ..localFlag = obj.localFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<PaymentGroupParameter> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PaymentGroupParameter>();
    lists.forEach((map) => result.add(PaymentGroupParameter.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnGroupId: this.groupId,
      columnGroupNo: this.groupNo,
      columnNo: this.no,
      columnStoreId: this.storeId,
      columnSign: this.sign,
      columnPbody: this.pbody,
      columnEnabled: this.enabled,
      columnCertText: this.certText,
      columnLocalFlag: this.localFlag,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
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
        groupId,
        groupNo,
        no,
        storeId,
        sign,
        pbody,
        enabled,
        certText,
        localFlag,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
