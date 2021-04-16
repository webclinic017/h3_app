import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class Worker extends BaseEntity {
  ///表名称
  static final String tableName = "pos_worker";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnPwdType = "pwdType";
  static final String columnPasswd = "passwd";
  static final String columnName = "name";
  static final String columnMobile = "mobile";
  static final String columnSex = "sex";
  static final String columnBirthday = "birthday";
  static final String columnOpenId = "openId";
  static final String columnBindingStatus = "bindingStatus";
  static final String columnStoreId = "storeId";
  static final String columnType = "type";
  static final String columnSalesRate = "salesRate";
  static final String columnJob = "job";
  static final String columnJobRate = "jobRate";
  static final String columnSuperId = "superId";
  static final String columnDiscount = "discount";
  static final String columnFreeAmount = "freeAmount";
  static final String columnStatus = "status";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnMemo = "memo";
  static final String columnLastTime = "lastTime";
  static final String columnCloudLoginFlag = "cloudLoginFlag";
  static final String columnPosLoginFlag = "posLoginFlag";
  static final String columnDataAuthFlag = "dataAuthFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnGiftRate = "giftRate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,no,pwdType,passwd,name,mobile,sex,birthday,openId,bindingStatus,storeId,type,salesRate,job,jobRate,superId,discount,freeAmount,status,deleteFlag,memo,lastTime,cloudLoginFlag,posLoginFlag,dataAuthFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,giftRate  from pos_worker;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_worker(id,tenantId,no,pwdType,passwd,name,mobile,sex,birthday,openId,bindingStatus,storeId,type,salesRate,job,jobRate,superId,discount,freeAmount,status,deleteFlag,memo,lastTime,cloudLoginFlag,posLoginFlag,dataAuthFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,giftRate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.no,entity.pwdType,entity.passwd,entity.name,entity.mobile,entity.sex,entity.birthday,entity.openId,entity.bindingStatus,entity.storeId,entity.type,entity.salesRate,entity.job,entity.jobRate,entity.superId,entity.discount,entity.freeAmount,entity.status,entity.deleteFlag,entity.memo,entity.lastTime,entity.cloudLoginFlag,entity.posLoginFlag,entity.dataAuthFlag,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate,entity.giftRate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_worker set id= '%s',tenantId= '%s',no= '%s',pwdType= '%s',passwd= '%s',name= '%s',mobile= '%s',sex= '%s',birthday= '%s',openId= '%s',bindingStatus= '%s',storeId= '%s',type= '%s',salesRate= '%s',job= '%s',jobRate= '%s',superId= '%s',discount= '%s',freeAmount= '%s',status= '%s',deleteFlag= '%s',memo= '%s',lastTime= '%s',cloudLoginFlag= '%s',posLoginFlag= '%s',dataAuthFlag= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s',giftRate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.no,this.pwdType,this.passwd,this.name,this.mobile,this.sex,this.birthday,this.openId,this.bindingStatus,this.storeId,this.type,this.salesRate,this.job,this.jobRate,this.superId,this.discount,this.freeAmount,this.status,this.deleteFlag,this.memo,this.lastTime,this.cloudLoginFlag,this.posLoginFlag,this.dataAuthFlag,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate,this.giftRate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_worker;"
  ///字段名称
  String no;
  int pwdType;
  String passwd;
  String name;
  String mobile;
  int sex;
  String birthday;
  String openId;
  int bindingStatus;
  String storeId;
  String type;
  double salesRate;
  String job;
  double jobRate;
  String superId;
  double discount;
  double freeAmount;
  int status;
  int deleteFlag;
  String memo;
  String lastTime;
  int cloudLoginFlag;
  int posLoginFlag;
  int dataAuthFlag;
  double giftRate;

  /// 当前操作员的模块权限
  List<String> permission = new List<String>();

  /// 当前操作员拥有的最大折扣额度，88代表8.8折
  double maxDiscountRate = 100;

  /// 最高免单金额   没有用到
  double maxFreeAmount = 0;

  ///默认构造
  Worker();

  ///Map转实体对象
  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..pwdType = Convert.toInt(map[columnPwdType])
      ..passwd = Convert.toStr(map[columnPasswd])
      ..name = Convert.toStr(map[columnName])
      ..mobile = Convert.toStr(map[columnMobile])
      ..sex = Convert.toInt(map[columnSex])
      ..birthday = Convert.toStr(map[columnBirthday])
      ..openId = Convert.toStr(map[columnOpenId])
      ..bindingStatus = Convert.toInt(map[columnBindingStatus])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..type = Convert.toStr(map[columnType])
      ..salesRate = Convert.toDouble(map[columnSalesRate])
      ..job = Convert.toStr(map[columnJob])
      ..jobRate = Convert.toDouble(map[columnJobRate])
      ..superId = Convert.toStr(map[columnSuperId])
      ..discount = Convert.toDouble(map[columnDiscount])
      ..freeAmount = Convert.toDouble(map[columnFreeAmount])
      ..status = Convert.toInt(map[columnStatus])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..memo = Convert.toStr(map[columnMemo])
      ..lastTime = Convert.toStr(map[columnLastTime])
      ..cloudLoginFlag = Convert.toInt(map[columnCloudLoginFlag])
      ..posLoginFlag = Convert.toInt(map[columnPosLoginFlag])
      ..dataAuthFlag = Convert.toInt(map[columnDataAuthFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..giftRate = Convert.toDouble(map[columnGiftRate]);
  }

  ///构建空对象
  factory Worker.newWorker() {
    return Worker()
      ..id = ""
      ..tenantId = ""
      ..no = ""
      ..pwdType = 0
      ..passwd = ""
      ..name = ""
      ..mobile = ""
      ..sex = 0
      ..birthday = ""
      ..openId = ""
      ..bindingStatus = 0
      ..storeId = ""
      ..type = ""
      ..salesRate = 0
      ..job = ""
      ..jobRate = 0
      ..superId = ""
      ..discount = 100
      ..freeAmount = 0
      ..status = 0
      ..deleteFlag = 0
      ..memo = ""
      ..lastTime = ""
      ..cloudLoginFlag = 0
      ..posLoginFlag = 0
      ..dataAuthFlag = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..giftRate = 0;
  }

  ///复制新对象
  factory Worker.clone(Worker obj) {
    return Worker()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..no = obj.no
      ..pwdType = obj.pwdType
      ..passwd = obj.passwd
      ..name = obj.name
      ..mobile = obj.mobile
      ..sex = obj.sex
      ..birthday = obj.birthday
      ..openId = obj.openId
      ..bindingStatus = obj.bindingStatus
      ..storeId = obj.storeId
      ..type = obj.type
      ..salesRate = obj.salesRate
      ..job = obj.job
      ..jobRate = obj.jobRate
      ..superId = obj.superId
      ..discount = obj.discount
      ..freeAmount = obj.freeAmount
      ..status = obj.status
      ..deleteFlag = obj.deleteFlag
      ..memo = obj.memo
      ..lastTime = obj.lastTime
      ..cloudLoginFlag = obj.cloudLoginFlag
      ..posLoginFlag = obj.posLoginFlag
      ..dataAuthFlag = obj.dataAuthFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..giftRate = obj.giftRate;
  }

  ///转List集合
  static List<Worker> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Worker>();
    lists.forEach((map) => result.add(Worker.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnPwdType: this.pwdType,
      columnPasswd: this.passwd,
      columnName: this.name,
      columnMobile: this.mobile,
      columnSex: this.sex,
      columnBirthday: this.birthday,
      columnOpenId: this.openId,
      columnBindingStatus: this.bindingStatus,
      columnStoreId: this.storeId,
      columnType: this.type,
      columnSalesRate: this.salesRate,
      columnJob: this.job,
      columnJobRate: this.jobRate,
      columnSuperId: this.superId,
      columnDiscount: this.discount,
      columnFreeAmount: this.freeAmount,
      columnStatus: this.status,
      columnDeleteFlag: this.deleteFlag,
      columnMemo: this.memo,
      columnLastTime: this.lastTime,
      columnCloudLoginFlag: this.cloudLoginFlag,
      columnPosLoginFlag: this.posLoginFlag,
      columnDataAuthFlag: this.dataAuthFlag,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnGiftRate: this.giftRate,
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
        pwdType,
        passwd,
        name,
        mobile,
        sex,
        birthday,
        openId,
        bindingStatus,
        storeId,
        type,
        salesRate,
        job,
        jobRate,
        superId,
        discount,
        freeAmount,
        status,
        deleteFlag,
        memo,
        lastTime,
        cloudLoginFlag,
        posLoginFlag,
        dataAuthFlag,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
        giftRate,
      ];
}
