import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class StoreInfo extends BaseEntity {
  ///表名称
  static final String tableName = "pos_store_info";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnCode = "code";
  static final String columnName = "name";
  static final String columnType = "type";
  static final String columnUpOrg = "upOrg";
  static final String columnUpOrgName = "upOrgName";
  static final String columnAskOrg = "askOrg";
  static final String columnAskOrgName = "askOrgName";
  static final String columnBalanceRate = "balanceRate";
  static final String columnPostPrice = "postPrice";
  static final String columnAddRate = "addRate";
  static final String columnAreaId = "areaId";
  static final String columnAreaPath = "areaPath";
  static final String columnStatus = "status";
  static final String columnContacts = "contacts";
  static final String columnTel = "tel";
  static final String columnMobile = "mobile";
  static final String columnOrderTel = "orderTel";
  static final String columnPrintName = "printName";
  static final String columnFax = "fax";
  static final String columnPostcode = "postcode";
  static final String columnAddress = "address";
  static final String columnEmail = "email";
  static final String columnAcreage = "acreage";
  static final String columnLng = "lng";
  static final String columnLat = "lat";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnWidth = "width";
  static final String columnHeight = "height";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnAuthFlag = "authFlag";
  static final String columnThirdNo = "thirdNo";
  static final String columnCreditAmount = "creditAmount";
  static final String columnCreditAmountUsed = "creditAmountUsed";
  static final String columnChargeLimit = "chargeLimit";
  static final String columnChargeLimitUsed = "chargeLimitUsed";
  static final String columnDefaultFlag = "defaultFlag";
  static final String columnStorePaySetting = "storePaySetting";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnWarehouseId = "warehouseId";
  static final String columnWarehouseNo = "warehouseNo";
  static final String columnMallStart = "mallStart";
  static final String columnMallEnd = "mallEnd";
  static final String columnMallBusinessFlag = "mallBusinessFlag";
  static final String columnMallStroeFlag = "MallStroeFlag";
  static final String columnAllowPurchase = "allowPurchase";
  static final String columnGroupId = "groupId";
  static final String columnGroupNo = "groupNo";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,code,name,type,upOrg,upOrgName,askOrg,askOrgName,balanceRate,postPrice,addRate,areaId,areaPath,status,contacts,tel,mobile,orderTel,printName,fax,postcode,address,email,acreage,lng,lat,deleteFlag,width,height,storageType,storageAddress,authFlag,thirdNo,creditAmount,creditAmountUsed,chargeLimit,chargeLimitUsed,defaultFlag,storePaySetting,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,warehouseId,warehouseNo,mallStart,mallEnd,mallBusinessFlag,MallStroeFlag,allowPurchase,groupId,groupNo  from pos_store_info;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_store_info(id,tenantId,code,name,type,upOrg,upOrgName,askOrg,askOrgName,balanceRate,postPrice,addRate,areaId,areaPath,status,contacts,tel,mobile,orderTel,printName,fax,postcode,address,email,acreage,lng,lat,deleteFlag,width,height,storageType,storageAddress,authFlag,thirdNo,creditAmount,creditAmountUsed,chargeLimit,chargeLimitUsed,defaultFlag,storePaySetting,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,warehouseId,warehouseNo,mallStart,mallEnd,mallBusinessFlag,MallStroeFlag,allowPurchase,groupId,groupNo  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[this.id,this.tenantId,this.code,this.name,this.type,this.upOrg,this.upOrgName,this.askOrg,this.askOrgName,this.balanceRate,this.postPrice,this.addRate,this.areaId,this.areaPath,this.status,this.contacts,this.tel,this.mobile,this.orderTel,this.printName,this.fax,this.postcode,this.address,this.email,this.acreage,this.lng,this.lat,this.deleteFlag,this.width,this.height,this.storageType,this.storageAddress,this.authFlag,this.thirdNo,this.creditAmount,this.creditAmountUsed,this.chargeLimit,this.chargeLimitUsed,this.defaultFlag,this.storePaySetting,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate,this.warehouseId,this.warehouseNo,this.mallStart,this.mallEnd,this.mallBusinessFlag,this.MallStroeFlag,this.allowPurchase,this.groupId,this.groupNo ];
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_store_info set id= '%s',tenantId= '%s',code= '%s',name= '%s',type= '%s',upOrg= '%s',upOrgName= '%s',askOrg= '%s',askOrgName= '%s',balanceRate= '%s',postPrice= '%s',addRate= '%s',areaId= '%s',areaPath= '%s',status= '%s',contacts= '%s',tel= '%s',mobile= '%s',orderTel= '%s',printName= '%s',fax= '%s',postcode= '%s',address= '%s',email= '%s',acreage= '%s',lng= '%s',lat= '%s',deleteFlag= '%s',width= '%s',height= '%s',storageType= '%s',storageAddress= '%s',authFlag= '%s',thirdNo= '%s',creditAmount= '%s',creditAmountUsed= '%s',chargeLimit= '%s',chargeLimitUsed= '%s',defaultFlag= '%s',storePaySetting= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s',warehouseId= '%s',warehouseNo= '%s',mallStart= '%s',mallEnd= '%s',mallBusinessFlag= '%s',MallStroeFlag= '%s',allowPurchase= '%s',groupId= '%s',groupNo= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.code,this.name,this.type,this.upOrg,this.upOrgName,this.askOrg,this.askOrgName,this.balanceRate,this.postPrice,this.addRate,this.areaId,this.areaPath,this.status,this.contacts,this.tel,this.mobile,this.orderTel,this.printName,this.fax,this.postcode,this.address,this.email,this.acreage,this.lng,this.lat,this.deleteFlag,this.width,this.height,this.storageType,this.storageAddress,this.authFlag,this.thirdNo,this.creditAmount,this.creditAmountUsed,this.chargeLimit,this.chargeLimitUsed,this.defaultFlag,this.storePaySetting,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate,this.warehouseId,this.warehouseNo,this.mallStart,this.mallEnd,this.mallBusinessFlag,this.MallStroeFlag,this.allowPurchase,this.groupId,this.groupNo ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_store_info;"
  ///字段名称
  String code;
  String name;
  int type;
  String upOrg;
  String upOrgName;
  String askOrg;
  String askOrgName;
  int balanceRate;
  int postPrice;
  double addRate;
  String areaId;
  String areaPath;
  int status;
  String contacts;
  String tel;
  String mobile;
  String orderTel;
  String printName;
  String fax;
  String postcode;
  String address;
  String email;
  double acreage;
  double lng;
  double lat;
  int deleteFlag;
  int width;
  int height;
  int storageType;
  String storageAddress;
  int authFlag;
  String thirdNo;
  double creditAmount;
  double creditAmountUsed;
  double chargeLimit;
  double chargeLimitUsed;
  int defaultFlag;
  int storePaySetting;
  String warehouseId;
  String warehouseNo;
  String mallStart;
  String mallEnd;
  int mallBusinessFlag;
  int MallStroeFlag;
  int allowPurchase;
  String groupId;
  String groupNo;

  ///默认构造
  StoreInfo();

  ///Map转实体对象
  factory StoreInfo.fromMap(Map<String, dynamic> map) {
    return StoreInfo()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..code = Convert.toStr(map[columnCode])
      ..name = Convert.toStr(map[columnName])
      ..type = Convert.toInt(map[columnType])
      ..upOrg = Convert.toStr(map[columnUpOrg])
      ..upOrgName = Convert.toStr(map[columnUpOrgName])
      ..askOrg = Convert.toStr(map[columnAskOrg])
      ..askOrgName = Convert.toStr(map[columnAskOrgName])
      ..balanceRate = Convert.toInt(map[columnBalanceRate])
      ..postPrice = Convert.toInt(map[columnPostPrice])
      ..addRate = Convert.toDouble(map[columnAddRate])
      ..areaId = Convert.toStr(map[columnAreaId])
      ..areaPath = Convert.toStr(map[columnAreaPath])
      ..status = Convert.toInt(map[columnStatus])
      ..contacts = Convert.toStr(map[columnContacts])
      ..tel = Convert.toStr(map[columnTel])
      ..mobile = Convert.toStr(map[columnMobile])
      ..orderTel = Convert.toStr(map[columnOrderTel])
      ..printName = Convert.toStr(map[columnPrintName])
      ..fax = Convert.toStr(map[columnFax])
      ..postcode = Convert.toStr(map[columnPostcode])
      ..address = Convert.toStr(map[columnAddress])
      ..email = Convert.toStr(map[columnEmail])
      ..acreage = Convert.toDouble(map[columnAcreage])
      ..lng = Convert.toDouble(map[columnLng])
      ..lat = Convert.toDouble(map[columnLat])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..width = Convert.toInt(map[columnWidth])
      ..height = Convert.toInt(map[columnHeight])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..authFlag = Convert.toInt(map[columnAuthFlag])
      ..thirdNo = Convert.toStr(map[columnThirdNo])
      ..creditAmount = Convert.toDouble(map[columnCreditAmount])
      ..creditAmountUsed = Convert.toDouble(map[columnCreditAmountUsed])
      ..chargeLimit = Convert.toDouble(map[columnChargeLimit])
      ..chargeLimitUsed = Convert.toDouble(map[columnChargeLimitUsed])
      ..defaultFlag = Convert.toInt(map[columnDefaultFlag])
      ..storePaySetting = Convert.toInt(map[columnStorePaySetting])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..warehouseId = Convert.toStr(map[columnWarehouseId])
      ..warehouseNo = Convert.toStr(map[columnWarehouseNo])
      ..mallStart = Convert.toStr(map[columnMallStart])
      ..mallEnd = Convert.toStr(map[columnMallEnd])
      ..mallBusinessFlag = Convert.toInt(map[columnMallBusinessFlag])
      ..MallStroeFlag = Convert.toInt(map[columnMallStroeFlag])
      ..allowPurchase = Convert.toInt(map[columnAllowPurchase])
      ..groupId = Convert.toStr(map[columnGroupId])
      ..groupNo = Convert.toStr(map[columnGroupNo]);
  }

  ///构建空对象
  factory StoreInfo.newStoreInfo() {
    return StoreInfo()
      ..id = ""
      ..tenantId = ""
      ..code = ""
      ..name = ""
      ..type = 0
      ..upOrg = ""
      ..upOrgName = ""
      ..askOrg = ""
      ..askOrgName = ""
      ..balanceRate = 0
      ..postPrice = 0
      ..addRate = 0
      ..areaId = ""
      ..areaPath = ""
      ..status = 0
      ..contacts = ""
      ..tel = ""
      ..mobile = ""
      ..orderTel = ""
      ..printName = ""
      ..fax = ""
      ..postcode = ""
      ..address = ""
      ..email = ""
      ..acreage = 0
      ..lng = 0
      ..lat = 0
      ..deleteFlag = 0
      ..width = 0
      ..height = 0
      ..storageType = 0
      ..storageAddress = ""
      ..authFlag = 0
      ..thirdNo = ""
      ..creditAmount = 0
      ..creditAmountUsed = 0
      ..chargeLimit = 0
      ..chargeLimitUsed = 0
      ..defaultFlag = 0
      ..storePaySetting = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..warehouseId = ""
      ..warehouseNo = ""
      ..mallStart = ""
      ..mallEnd = ""
      ..mallBusinessFlag = 0
      ..MallStroeFlag = 0
      ..allowPurchase = 0
      ..groupId = ""
      ..groupNo = "";
  }

  ///复制新对象
  factory StoreInfo.clone(StoreInfo obj) {
    return StoreInfo()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..code = obj.code
      ..name = obj.name
      ..type = obj.type
      ..upOrg = obj.upOrg
      ..upOrgName = obj.upOrgName
      ..askOrg = obj.askOrg
      ..askOrgName = obj.askOrgName
      ..balanceRate = obj.balanceRate
      ..postPrice = obj.postPrice
      ..addRate = obj.addRate
      ..areaId = obj.areaId
      ..areaPath = obj.areaPath
      ..status = obj.status
      ..contacts = obj.contacts
      ..tel = obj.tel
      ..mobile = obj.mobile
      ..orderTel = obj.orderTel
      ..printName = obj.printName
      ..fax = obj.fax
      ..postcode = obj.postcode
      ..address = obj.address
      ..email = obj.email
      ..acreage = obj.acreage
      ..lng = obj.lng
      ..lat = obj.lat
      ..deleteFlag = obj.deleteFlag
      ..width = obj.width
      ..height = obj.height
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..authFlag = obj.authFlag
      ..thirdNo = obj.thirdNo
      ..creditAmount = obj.creditAmount
      ..creditAmountUsed = obj.creditAmountUsed
      ..chargeLimit = obj.chargeLimit
      ..chargeLimitUsed = obj.chargeLimitUsed
      ..defaultFlag = obj.defaultFlag
      ..storePaySetting = obj.storePaySetting
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..warehouseId = obj.warehouseId
      ..warehouseNo = obj.warehouseNo
      ..mallStart = obj.mallStart
      ..mallEnd = obj.mallEnd
      ..mallBusinessFlag = obj.mallBusinessFlag
      ..MallStroeFlag = obj.MallStroeFlag
      ..allowPurchase = obj.allowPurchase
      ..groupId = obj.groupId
      ..groupNo = obj.groupNo;
  }

  ///转List集合
  static List<StoreInfo> toList(List<Map<String, dynamic>> lists) {
    var result = new List<StoreInfo>();
    lists.forEach((map) => result.add(StoreInfo.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnCode: this.code,
      columnName: this.name,
      columnType: this.type,
      columnUpOrg: this.upOrg,
      columnUpOrgName: this.upOrgName,
      columnAskOrg: this.askOrg,
      columnAskOrgName: this.askOrgName,
      columnBalanceRate: this.balanceRate,
      columnPostPrice: this.postPrice,
      columnAddRate: this.addRate,
      columnAreaId: this.areaId,
      columnAreaPath: this.areaPath,
      columnStatus: this.status,
      columnContacts: this.contacts,
      columnTel: this.tel,
      columnMobile: this.mobile,
      columnOrderTel: this.orderTel,
      columnPrintName: this.printName,
      columnFax: this.fax,
      columnPostcode: this.postcode,
      columnAddress: this.address,
      columnEmail: this.email,
      columnAcreage: this.acreage,
      columnLng: this.lng,
      columnLat: this.lat,
      columnDeleteFlag: this.deleteFlag,
      columnWidth: this.width,
      columnHeight: this.height,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnAuthFlag: this.authFlag,
      columnThirdNo: this.thirdNo,
      columnCreditAmount: this.creditAmount,
      columnCreditAmountUsed: this.creditAmountUsed,
      columnChargeLimit: this.chargeLimit,
      columnChargeLimitUsed: this.chargeLimitUsed,
      columnDefaultFlag: this.defaultFlag,
      columnStorePaySetting: this.storePaySetting,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnWarehouseId: this.warehouseId,
      columnWarehouseNo: this.warehouseNo,
      columnMallStart: this.mallStart,
      columnMallEnd: this.mallEnd,
      columnMallBusinessFlag: this.mallBusinessFlag,
      columnMallStroeFlag: this.MallStroeFlag,
      columnAllowPurchase: this.allowPurchase,
      columnGroupId: this.groupId,
      columnGroupNo: this.groupNo,
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
        code,
        name,
        type,
        upOrg,
        upOrgName,
        askOrg,
        askOrgName,
        balanceRate,
        postPrice,
        addRate,
        areaId,
        areaPath,
        status,
        contacts,
        tel,
        mobile,
        orderTel,
        printName,
        fax,
        postcode,
        address,
        email,
        acreage,
        lng,
        lat,
        deleteFlag,
        width,
        height,
        storageType,
        storageAddress,
        authFlag,
        thirdNo,
        creditAmount,
        creditAmountUsed,
        chargeLimit,
        chargeLimitUsed,
        defaultFlag,
        storePaySetting,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
        warehouseId,
        warehouseNo,
        mallStart,
        mallEnd,
        mallBusinessFlag,
        MallStroeFlag,
        allowPurchase,
        groupId,
        groupNo,
      ];
}
