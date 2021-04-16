import 'package:h3_app/printer/plugins/printer_constant.dart';

class SqlConstant {
  //初始化表
  static List<String> initTables = [
    ///POS注册登记表
    "create table if not exists pos_authc(id varchar(24)  not null unique primary key,tenantId varchar(16)not null,compterName varchar(32),macAddress varchar(128),diskSerialNumber varchar(32),cpuSerialNumber varchar(32),storeId varchar(24),storeNo varchar(16),storeName varchar(64),posId varchar,posNo varchar(16),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///开放平台访问参数表
    "create table if not exists pos_apis(id varchar(24) not null unique,tenantId varchar(16) not null,apiType varchar(16) not null,appKey varchar(32),appSecret varchar(32),locale varchar(16),format varchar(8),client varchar(16),version varchar(8),routing int not null default 0,memo varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///开放平台访问地址表
    "create table pos_urls(id varchar(24) not null unique,tenantId varchar(16) not null,apiType varchar(24) not null,protocol varchar(8) default http,url varchar(64),contextPath varchar(64) not null,userDefined int not null default 0,enable int not null default 0,memo varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///通用版本-初始化数据
    "insert into pos_apis (id,tenantId,apiType,appKey,appSecret,locale,format,client,version,routing,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('392346017497878528','373001','Business','ZXzwVaNA2DCwNZD5YmzA','56055e8b68657fe273e1d4f6ba8d3c21','zh-CN','json','Android','1.0','1','业务系统默认参数','','','','sync','2019-10-19 16:09:10','sync','2019-10-19 16:09:10');",
    "insert into pos_apis (id,tenantId,apiType,appKey,appSecret,locale,format,client,version,routing,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('392372693334233088','373001','WaiMai','ZXzwVaNA2DCwNZD5YmzA','56055e8b68657fe273e1d4f6ba8d3c21','zh-CN','json','Android','1.0','1','外卖系统默认参数','','','','sync','2019-10-19 16:09:10','sync','2019-10-19 16:09:10');",

    ///通用版本客户
    "insert into pos_urls (id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('392347527434735616','373001','Business','http','api.jwsaas.com','api','0','1','业务系统默认地址','','','','sync','2019-10-19 16:12:12','sync','2019-10-19 16:12:12');",
    "insert into pos_urls (id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('392347779105558529','373001','WaiMai','http','apiwm.jwsaas.com','api','0','1','外卖系统默认地址','','','','sync','2019-10-19 16:12:12','sync','2019-10-19 16:12:12');",

    // ///私有化部署客户-571101-小呗出行
    // "insert into pos_urls (id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('874095336606535680','571101','Business','http','api.squirrel-man.com','api','0','1','业务系统默认地址','','','','sync','2019-10-19 16:12:12','sync','2019-10-19 16:12:12');",
    // "insert into pos_urls (id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('874095336606535681','571101','WaiMai','http','apiwm.squirrel-man.com','api','0','1','外卖系统默认地址','','','','sync','2019-10-19 16:12:12','sync','2019-10-19 16:12:12');",
    // "insert into pos_urls (id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate)values('874095336606535684','571101','MQTT','http','msg.squirrel-man.com:18830','','0','1','外卖系统默认地址','','','','sync','2019-10-19 16:12:12','sync','2019-10-19 16:12:12');",

    ///全局配置参数表
    "create table if not exists pos_config(id varchar(24) primary key unique not null,tenantId varchar(16) not null,`group` char(32) not null,keys varchar(64) not null,initValue text,`values` text,clouds text,createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///参数配置表添加唯一索引
    "create unique index if not exists inx_pos_config_keys on pos_config(`group`,keys);",

    ///门店员工表
    "create table if not exists pos_worker(id varchar(24) primary key unique not null,tenantId varchar(16),`no` varchar(32),pwdType int,passwd varchar(64),name varchar(64),mobile varchar(16),sex int,birthday varchar(32),openId varchar(64),bindingStatus int,storeId varchar(24),type varchar(12),salesRate decimal(24,4),job varchar(32),jobRate decimal(24,4),superId varchar(24),discount varchar(8),freeAmount varchar(8),status int,deleteFlag int,memo varchar(128),lastTime varchar(32),cloudLoginFlag int,posLoginFlag int,dataAuthFlag int,giftRate decimal(24,4) default 0,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///员工角色表
    "create table if not exists pos_worker_role(id varchar(24) primary key unique not null,tenantId varchar(16),userId varchar(24),roleId varchar(24),discount decimal(24,4),freeAmount decimal(24,4),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///员工模块权限表
    "create table if not exists pos_worker_module(id varchar(24) primary key unique not null,tenantId varchar(16),userId varchar(24),moduleNo varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///员工数据权限
    "create table if not exists pos_worker_data(id varchar(24) primary key unique not null,tenantId varchar(16),workerId varchar(24),type varchar(32),groupName varchar(32),auth varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品品牌表
    "create table if not exists pos_product_brand(id varchar(24) primary key not null unique,tenantId varchar(16) not null,name varchar(64),returnRate int,storageType int,storageAddress varchar(256),orderNo int,products int,deleteFlag int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品分类表
    "create table if not exists pos_product_category(id varchar(24)  primary key not null unique,tenantId varchar(16) not null,parentId varchar(24),name varchar(64),code varchar(32),path varchar(128),categoryType int,english varchar(128),returnRate int,description varchar(128),orderNo int,deleteFlag int,products int default(0),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品单位表
    "create table if not exists pos_product_unit(id varchar(24) primary key unique not null,tenantId varchar(16),`no` varchar(16),name varchar(64),deleteFlag int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品资料表
    "create table if not exists pos_product(id varchar(24) primary key unique not null,tenantId varchar(16),categoryId varchar(24),categoryPath varchar(256),type int,`no` varchar(32),barCode varchar(32),subNo varchar(32),otherNo varchar(32),name varchar(512),english varchar(512),rem varchar(512),shortName varchar(512),unitId varchar(24),brandId varchar(24),storageType int,storageAddress varchar(256),supplierId varchar(24),managerType varchar(8),purchaseControl int,purchaserCycle decimal(24,4),validDays decimal(24,4),productArea varchar(128),status int,spNum int,stockFlag int,batchStockFlag int,weightFlag int,weightWay int,steelyardCode varchar(32),labelPrintFlag int,foreDiscount int,foreGift int,promotionFlag int,branchPrice int,foreBargain int,returnType int,returnRate decimal(24,4),pointFlag int,pointValue decimal(24,4),introduction text,purchaseTax decimal(24,4),saleTax decimal(24,4),lyRate decimal(24,4),allCode varchar(256),deleteFlag int,allowEditSup int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),quickInventoryFlag int,posSellFlag int default 1);",

    ///商品附加码
    "create table if not exists pos_product_code(id varchar(24) primary key unique not null,tenantId varchar(16),productId varchar(24),specId varchar(24),code varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品关联信息
    "create table if not exists pos_product_contact(id varchar(24) primary key unique not null,tenantId varchar(16),masterId varchar(24),masterSpecId varchar(24),slaveId varchar(24),slaveSpecId varchar(24),slaveNum decimal(24,4),deleteFlag int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),orderNo int,createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///商品规格表
    "create table if not exists pos_product_spec(id varchar(24) primary key unique not null,tenantId varchar(16),productId varchar(24),specNo varchar(16),specification varchar(128),purPrice decimal(24,4),salePrice decimal(24,4),minPrice decimal(24,4),vipPrice decimal(24,4),vipPrice2 decimal(24,4),vipPrice3 decimal(24,4),vipPrice4 decimal(24,4),vipPrice5 decimal(24,4),postPrice decimal(24,4),batchPrice decimal(24,4),batchPrice2 decimal(24,4),batchPrice3 decimal(24,4),batchPrice4 decimal(24,4),batchPrice5 decimal(24,4),batchPrice6 decimal(24,4),batchPrice7 decimal(24,4),batchPrice8 decimal(24,4),otherPrice decimal(24,4),purchaseSpec decimal(24,4),status int,storageType int,storageAddress varchar(256),deleteFlag int,isDefault int,topLimit decimal(24,4),lowerLimit decimal(24,4),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///门店商品表
    "create table if not exists pos_store_product(id varchar(24)  primary key unique not null,tenantId varchar(16),storeId varchar(24),productId varchar(24),specId varchar(24),purPrice decimal(24,4),salePrice decimal(24,4),minPrice decimal(24,4),vipPrice decimal(24,4),vipPrice2 decimal(24,4),vipPrice3 decimal(24,4),vipPrice4 decimal(24,4),vipPrice5 decimal(24,4),postPrice decimal(24,4),batchPrice decimal(24,4),batchPrice2 decimal(24,4),batchPrice3 decimal(24,4),batchPrice4 decimal(24,4),batchPrice5 decimal(24,4),batchPrice6 decimal(24,4),batchPrice7 decimal(24,4),batchPrice8 decimal(24,4),otherPrice decimal(24,4),supplierId varchar(24),status int,topLimit decimal(24,4),lowerLimit decimal(24,4),purchaseDate varchar(32),lastDate varchar(32),pointFlag int,foreGift int,foreDiscount int,stockFlag int,foreBargain int,branchPrice int,managerType varchar(8),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));",

    ///POS模块表
    "create table if not exists pos_module (id varchar (24) not null unique primary key, tenantId varchar (16) not null, area varchar (16) not null, name varchar (16) not null, alias varchar (16) not null, keycode varchar (16) not null, keydata varchar (64), color1 varchar (16) not null default '0xFFFFFFFF', color2 varchar (16) not null default '0xFFFFFFFF', color3 varchar (16) not null default '0xFFFFFFFF', color4 varchar (16), fontSize varchar (16) not null default 默认, shortcut varchar (16), orderNo int not null default 0, icon varchar (16), enable int not null default 0, permission varchar (16), createUser varchar (16), createDate varchar (32), modifyUser varchar (16), modifyDate varchar (32) ); ",

    ///初始化POS模块表数据
    """
    insert into pos_module (id, tenantId, area, name, alias, keycode, keydata, color1, color2, color3, color4, fontSize, shortcut, orderNo, icon, enable, permission, createUser, createDate, modifyUser, modifyDate) values 
     ('880310747656228864', '373001', '快捷', '删除', '删除', '删除单品', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 1, '', 1, '10002', 'sync', '2017-06-30 14:23:32', 'sync', '2018-10-26 09:38:30'),
     ('880310755910619136', '373001', '快捷', '消单', '消单', '取消全单', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 14, '', 1, '10001', 'sync', '2017-06-30 14:23:34', 'sync', '2018-10-26 09:38:36'),  
     ('880310797832687616', '373001', '快捷', '➕', '➕', '数量加', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 10, '', 1, '10004', 'sync', '2017-06-30 14:23:44', 'sync', '2018-10-26 09:38:37'), 
     ('880310799611072512', '373001', '快捷', '➖', '➖', '数量减', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 11, '', 1, '10005', 'sync', '2017-06-30 14:23:44', 'sync', '2018-10-26 09:38:37'), 
     ('880340328257818624', '373001', '快捷', '数量', '数量', '数量', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 2, '', 1, '10003', 'sync', '2017-06-30 16:21:04', 'sync', '2018-10-26 09:38:30'), 
     ('886130906824314880', '373001', '快捷', '做法', '做法', '做法', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 14, '', 1, '10006', 'sync', '2017-07-16 07:50:46', 'sync', '2018-10-26 09:38:30'), 
     ('886130909231845376', '373001', '快捷', '规格', '规格', '规格', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 12, '', 1, '10007', 'sync', '2017-07-16 07:50:46', 'sync', '2018-10-26 09:38:37'), 
     ('889417104615411712', '373001', '快捷', '会员', '会员', '会员', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 0, '', 1, '10009', 'sync', '2017-07-25 01:28:56', 'sync', '2018-10-26 09:38:30'), 
     ('914058948083060736', '373001', '快捷', '折扣', '折扣', '折扣', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 3, '', 1, '10011', 'sync', '2017-09-30 17:26:50', 'sync', '2018-10-26 09:38:30'), 
     ('914058950972936192', '373001', '快捷', '改价', '改价', '改价', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 4, '', 1, '10012', 'sync', '2017-09-30 17:26:50', 'sync', '2018-10-26 09:38:30'), 
     ('914058953934114816', '373001', '快捷', '赠送', '赠送', '赠送', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 5, '', 1, '10010', 'sync', '2017-09-30 17:26:51', 'sync', '2018-10-26 09:38:30'), 
     ('871308957472395278', '373001', '结账', '结账', '结账', '结账', '', '#FF391D', '#FF391D', 'White', '#FF391D', '大字', '', 0, '', 1, '', 'sync', '2017-07-26 02:28:56', 'sync', '2017-07-26 02:28:56'), 
     ('871308957472395279', '373001', '快捷', '导购', '导购', '导购', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 7, '', 1, '10013', 'sync', '2017-07-26 02:28:56', 'sync', '2018-10-26 09:38:35'), 
     ('1042736335527481344', '373001', '其他', '锁屏', '锁屏', '锁屏', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 4, '', 1, '10022', 'sync', '2018-09-20 19:24:57', 'sync', '2018-09-22 09:35:13'), 
     ('1042737512897974272', '373001', '其他', '充值', '充值', '会员卡充值', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 1, '', 1, '20002', 'sync', '2018-09-20 19:29:40', 'sync', '2018-09-22 09:35:13'), 
     ('1042737602337312768', '373001', '其他', '交班', '交班', '交班', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 9, '', 1, '10018', 'sync', '2018-09-20 19:29:59', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735872', '373001', '其他', '退货', '退货', '退货', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 6, '', 1, '10019', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042958244391292928', '373001', '更多', '盘点单', '盘点单', '盘点单', '', '#E7EAF1', '#E7EAF1', '#444444', '#444444', '大字', '', 0, '', 1, '50011', 'sync', '2018-09-21 10:06:47', 'sync', '2018-10-26 09:38:30'), 
     ('1042958296262250496', '373001', '更多', '开发票', '开发票', '开发票', '', '#E7EAF1', '#E7EAF1', '#444444', '#444444', '大字', '', 1, '', 1, '', 'sync', '2018-09-21 10:07:07', 'sync', '2018-10-26 09:38:30'), 
     ('1042740964390735873', '373001', '其他', '新增会员', '新增会员', '会员卡开户', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 0, '', 1, '20001', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735874', '373001', '其他', '计次充值', '计次充值', '计次充值', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 2, '', 1, '20011', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735875', '373001', '其他', '计次消费', '计次消费', '计次消费', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 3, '', 1, '20012', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735876', '373001', '其他', '交易查询', '交易查询', '销售流水', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 5, '', 1, '30001', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735877', '373001', '其他', '库存查询', '库存查询', '库存查询', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 7, '', 1, '50019', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('1042740964390735878', '373001', '其他', '门店要货', '门店要货', '要货单', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 8, '', 1, '50001', 'sync', '2018-09-20 19:43:19', 'sync', '2018-09-22 09:35:13'), 
     ('880310797832687617', '373001', '快捷', '清零', '清零', '清零', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 8, '', 1, '10014', 'sync', '2017-06-30 14:23:44', 'sync', '2018-10-26 09:38:38'), 
     ('880310797832687618', '373001', '快捷', '去皮', '去皮', '去皮', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 9, '', 1, '10015', 'sync', '2017-06-30 14:23:44', 'sync', '2018-10-26 09:38:38'), 
     ('880310797832687619', '373001', '快捷', '凑整', '凑整', '凑整', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 6, '', 1, '10023', 'sync', '2017-06-30 14:23:44', 'sync', '2018-10-26 09:38:38'), 
     ('914058948083060720', '373001', '快捷', '寄存', '寄存', '寄存', '', '#E7EAF1', '#E7EAF1', '#444444', '#E7EAF1', '大字', '', 10, '', 1, '10024', 'sync', '2019-01-30 10:21:30', 'sync', '2019-01-30 10:21:30'), 
     ('914058948083060721', '373001', '其他', '新建寄存', '新建寄存', '新建寄存', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 11, '', 1, '10025', 'sync', '2019-01-30 10:21:30', 'sync', '2019-01-30 10:21:30'), 
     ('914058948083060722', '373001', '其他', '寄存取货', '寄存取货', '寄存取货', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 12, '', 1, '10026', 'sync', '2019-01-30 10:21:30', 'sync', '2019-01-30 10:21:30'), 
     ('914058948083060723', '373001', '其他', '开钱箱', '开钱箱', '开钱箱', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 13, '', 1, '10027', 'sync', '2019-01-30 10:21:30', 'sync', '2019-01-30 10:21:30'), 
     ('914058948083060724', '373001', '其他', '补打', '补打', '补打', '', 'White', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 15, '', 1, '10028', 'sync', '2019-05-17 15:33:30', 'sync', '2019-05-17 15:33:30'), 
     ('914058948083060725', '373001', '其他', '打印开关', '打印开关', '打印开关', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 16, '', 1, '10029', 'sync', '2019-05-17 16:00:00', 'sync', '2019-05-17 16:00:00'), 
     ('914058948083060726', '373001', '更多', '连续称重', '连续称重', '连续称重', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 16, '', 1, '10031', 'sync', '2019-07-30 16:00:00', 'sync', '2019-07-30 16:00:00'), 
     ('914058948083060727', '373001', '更多', '桌号', '桌号', '桌号', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 17, '', 1, '10034', 'sync', '2019-07-30 16:00:00', 'sync', '2019-07-30 16:00:00'), 
     ('914058948083060728', '373001', '更多', '快速调价', '快速调价', '快速调价', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 3, '', 1, '10032', 'sync', '2019-07-31 16:00:00', 'sync', '2019-07-31 16:00:00'), 
     ('914058948083060729', '373001', '更多', '调价模式', '调价模式', '调价模式', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 4, '', 1, '10033', 'sync', '2019-08-02 09:20:00', 'sync', '2019-08-02 09:20:00'), 
     ('914058948083060730', '373001', '更多', '快速盘点', '快速盘点', '快速盘点', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 5, '', 1, '10035', 'sync', '2019-08-02 09:20:00', 'sync', '2019-08-02 09:20:00'), 
     ('914058948083060731', '373001', '更多', '备注', '备注', '备注', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 6, '', 1, '', 'sync', '2019-08-20 16:20:00', 'sync', '2019-08-20 16:20:00'), 
     ('914058948083060732', '373001', '更多', '连续开关', '连续开关', '连续开关', '', '#E7EAF1', '#E7EAF1', '#4AB3FD', '#4AB3FD', '大字', '', 7, '', 1, '', 'sync', '2019-08-21 10:00:00', 'sync', '2019-08-21 10:00:00'); 
    """,

    ///商品供应商表
    """
    create table if not exists pos_supplier(id varchar(24) primary key unique not null,tenantId varchar(16),`no` varchar(64),name varchar(64),rem varchar(32),purchaseCycle int,managerType varchar(8),dealOrganize varchar(24),defaultPrice int,dealType int,dealCycle int,
    dealDate int,costRate decimal(24,4),minAmount decimal(24,4),contacts varchar(64),tel varchar(16),address varchar(256),fax varchar(16),postcode varchar(16),email varchar(64),bankName varchar(32),bankCardNo varchar(32),taxId varchar(32),companyType int,frozenMoney int,frozenBusiness int,busStorageType int,businessPic varchar(256),licStorageType int,licensePic varchar(256),prePayAmount decimal(24,4),orderNo int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    
    """,

    ///厨打方案表
    """
    create table if not exists pos_kit_plan(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,name varchar(64) ,type varchar(8) ,description varchar(128) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///厨打方案商品表
    """
    create table if not exists pos_kit_plan_product(id varchar(24) primary key unique not null,tenantId varchar(16),productId varchar(24),chudaFlag int,chuda varchar(24),chupinFlag int,chupin varchar(24),labelFlag int,labelValue varchar(24),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    
    """,

    ///PLUS商品表
    """    
    create table if not exists pos_product_plus(id varchar(24) primary key unique not null,tenantId varchar(16),ticketId varchar(24),ticketNo varchar(32),productId varchar(24),productNo varchar(32),productName varchar(64),vipPrice decimal(24,4),
    salePrice decimal(24,4),plusDiscount decimal(24,4),plusPrice decimal(24,4),description varchar(128),specId varchar(24),specName varchar(32),validStartDate varchar(32),validendDate varchar(32),subNo varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    
    """,

    ///辅助信息表，各种原因数据存储
    """
    create table if not exists pos_base_parameter(id varchar(24) primary key unique not null,tenantId varchar(16),parentId varchar(24),code varchar(32),name varchar(32),memo varchar(32),orderNo int,enabled int,ext1 varchar(32),ext2 varchar(32),ext3 
    varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));

    """,

    ///支付方式表
    """
    create table if not exists pos_pay_mode(id varchar(24) primary key unique not null,tenantId varchar(16)not null,`no` varchar(16)not null,name varchar(32)not null,shortcut varchar(16),pointFlag int,frontFlag int,backFlag int,rechargeFlag int,faceMoney decimal(24,4)
    default 0,paidMoney decimal(24,4)default 0,incomeFlag int,plusFlag int default 0,orderNo int default(0),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),deleteFlag int,createDate varchar(32),createUser varchar(32),modifyDate varchar(32),modifyUser 
    varchar(32));

    """,

    ///支付参数表
    """
    create table if not exists pos_payment_parameter(id varchar(24) primary key unique not null,tenantId varchar(16)not null,`no` varchar(16),storeId varchar(32),sign varchar(16),pbody text,enabled int,certText text,localFlag int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),
    createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));

    """,

    ///充值支付参数
    """
    create table if not exists pos_payment_group_parameter(id varchar(24) primary key not null,tenantId varchar(16)not null,groupId varchar(24),groupNo varchar(32),`no` varchar(16),storeId varchar(32),sign varchar(16),pbody text,enabled int,certText text,localFlag int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///订单主表
    """
    create table if not exists pos_order(id varchar(24) not null unique,tenantId varchar(16)not null,objectId varchar(32),orderNo varchar(16),tradeNo varchar(32),storeId varchar(24),storeNo varchar(24),storeName varchar(512),workerNo varchar(24),workerName varchar(24),saleDate varchar(32),finishDate varchar(32),tableNo varchar(32),tableName varchar(64),salesCode varchar(128),salesName varchar(128),posNo varchar(24),deviceName varchar(64),macAddress varchar(128),ipAddress varchar(24),itemCount int,payCount int,totalQuantity decimal(24,4),amount decimal(24,4),discountAmount decimal(24,4),receivableAmount decimal(24,4),paidAmount decimal(24,4),receivedAmount decimal(24,4),malingAmount decimal(24,4),changeAmount decimal(24,4),invoicedAmount decimal(24,4),overAmount decimal(24,4),orderStatus int,paymentStatus int,printStatus int,printTimes int,postWay int,orderSource int(32),people int,shiftId varchar(24),shiftNo varchar(32),shiftName varchar(32),discountRate decimal(24,4),orgTradeNo varchar(32),refundCause varchar(512),isMember integer,memberNo varchar(32),memberName varchar(32),memberMobileNo varchar(32),cardFaceNo varchar(64),prePoint decimal(24,4)default 0,addPoint decimal(24,4),refundPoint decimal(24,4)default(0),aftPoint decimal(24,4),aftAmount decimal(24,4)default(0),uploadStatus int,uploadErrors int,uploadCode varchar(32),uploadMessage varchar(128),serverId varchar(32),uploadTime varchar(32),weather varchar(24),weeker varchar(24),remark varchar(256),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),memberId varchar(32),receivableRemoveCouponAmount decimal(24,4),isPlus int,plusDiscountAmount decimal(24,4),freightAmount decimal(24,4)default 0,realPayAmount decimal(24,4)default 0);
    
    """,

    ///订单明细表
    """
    create table if not exists pos_order_item(id  varchar(24)   not null unique,tenantId varchar(16)not null,orderId varchar(24),tradeNo varchar(32),orderNo int,productId varchar(32),productName varchar(64),shortName varchar(32),specId varchar(24),specName varchar(32),displayName varchar(32),quantity decimal(24,4),rquantity decimal(24,4),ramount decimal(24,4),orgItemId varchar(32),salePrice decimal(24,4),price decimal(24,4),bargainReason varchar(128),discountPrice decimal(24,4),vipPrice decimal(24,4),otherPrice decimal(24,4),batchPrice decimal(24,4),postPrice decimal(24,4),purPrice decimal(24,4),minPrice decimal(24,4),giftQuantity decimal(24,4),giftAmount decimal(24,4),giftReason varchar(128),flavorCount int,flavorNames varchar(128),flavorAmount decimal(24,4),flavorDiscountAmount decimal(24,4),flavorReceivableAmount decimal(24,4),amount decimal(24,4),totalAmount decimal(24,4),discountAmount decimal(24,4),receivableAmount decimal(24,4),totalDiscountAmount decimal(24,4),totalReceivableAmount decimal(24,4),discountRate decimal(24,4),totalDiscountRate decimal(24,4),malingAmount decimal(24,4)default(0),remark varchar(256),saleDate varchar(32),finishDate varchar(24),cartDiscount decimal(24,4),underline int,`group` varchar(24),parentId varchar(32),flavor int,scheme varchar(128),rowType int,suitId varchar(24),suitQuantity decimal(24,4),suitAddPrice decimal(24,4),suitAmount decimal(24,4),chuda varchar(24),chudaFlag varchar(8),chudaQty decimal(24,4),chupin varchar(24),chupinFlag varchar(8),chupinQty decimal(24,4),productType int,barCode varchar(32),subNo varchar(32),batchNo varchar(32),productUnitId varchar(32),productUnitName varchar(32),categoryId varchar(24),categoryNo varchar(32),categoryName varchar(32),brandId varchar(24),brandName varchar(64),foreDiscount int,weightFlag int,weightWay int,foreBargain int,pointFlag int,pointValue decimal(24,4),foreGift int,promotionFlag int,stockFlag int,batchStockFlag int,labelPrintFlag int,labelQty decimal(24,4),purchaseTax decimal(24,4),saleTax decimal(24,4),supplierId varchar(24),supplierName varchar(128),managerType varchar(16),salesCode varchar(32),salesName varchar(64),itemSource int,posNo varchar(16),addPoint decimal(24,4)default(0),refundPoint decimal(24,4)default(0),promotionInfo varchar(512),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),lyRate decimal(24,4)default 0,chuDaLabel varchar(24),chuDaLabelFlag varchar(8),chuDaLabelQty decimal(24,4),shareCouponLeastCost decimal(24,4),couponAmount decimal(24,4),totalReceivableRemoveCouponAmount decimal(24,4),totalReceivableRemoveCouponLeastCost decimal(24,4),joinType int default 0,labelAmount decimal(24,4)default 0,isPlusPrice int,realPayAmount decimal(24,4)default 0,shareMemberId varchar(32));
    """,

    ///订单明细做法表
    """
    create table if not exists pos_order_item_make(id varchar(24)  not null unique,tenantId varchar(16)not null,tradeNo varchar(32),orderId varchar(24),itemId varchar(24),makeId varchar(24),code varchar(16),name varchar(16),qtyFlag int,quantity decimal(24,4),refund decimal(24,4),salePrice decimal(24,4),price decimal(24,4),amount decimal(24,4),discountAmount decimal(24,4),receivableAmount decimal(24,4),discountRate decimal(24,4),TYPE int,isRadio integer,description varchar(24),hand decimal(24,4),`group` varchar(32),baseQuantity decimal(24,4),itemQuantity decimal(24,4),finishDate varchar(24),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    """,

    ///订单明细支付表
    """
    create table if not exists pos_order_item_pay(id  varchar(24)   not null unique,tenantId varchar(16)not null,orderId varchar(24),tradeNo varchar(32),itemId varchar(24),productId varchar(24),specId varchar(24),payId varchar(24),`no` varchar(32),name varchar(32),couponId varchar(24),couponNo varchar(32),couponName varchar(32),faceAmount decimal(24,4),shareCouponLeastCost decimal(24,4),shareAmount decimal(24,4),ramount decimal(24,4),finishDate varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),sourceSign varchar(32),incomeFlag int default 0);
    """,

    ///订单明细优惠表
    """
    create table if not exists pos_order_item_promotion(id  varchar(24)   not null unique,tenantId varchar(16)not null,orderId varchar(24),itemId varchar(24),tradeNo varchar(32),onlineFlag int,promotionType int,reason varchar(128),scheduleId varchar(24),scheduleSn varchar(24),promotionId varchar(24),promotionSn varchar(24),promotionMode varchar(8),scopeType varchar(8),promotionPlan varchar(64),price decimal(24,4),bargainPrice decimal(24,4),amount decimal(24,4),discountAmount decimal(24,4),receivableAmount decimal(24,4),discountRate decimal(24,4),enabled int,relationId int,couponId varchar(24),couponNo varchar(32),couponName varchar(128),finishDate varchar(24),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),sourceSign varchar(32));
    """,

    ///订单支付表
    """
    create table if not exists pos_order_pay(id varchar(24)   not null unique,tenantId varchar(16)not null,tradeNo varchar(32),orderId varchar(32),orgPayId varchar(32),orderNo int,`no` varchar(32),name varchar(32),amount decimal(24,4),inputAmount decimal(24,4),faceAmount decimal(24,4),paidAmount decimal(24,4),ramount decimal(24,4),overAmount decimal(24,4),changeAmount decimal(24,4),platformDiscount decimal(24,4),platformPaid decimal(24,4),payNo varchar(64),prePayNo varchar(64),channelNo varchar(64),voucherNo varchar(64),status varchar(32),statusDesc varchar(64),payTime varchar(32),finishDate varchar(24),payChannel int default(-1),incomeFlag int default 0,pointFlag int,subscribe int,useConfirmed int,accountName varchar(128),bankType varchar(16),memo varchar(64),cardNo varchar(24),cardPreAmount decimal(24,4),cardChangeAmount decimal(24,4),cardAftAmount decimal(24,4),cardPrePoint decimal(24,4),cardChangePoint decimal(24,4),cardAftPoint decimal(24,4),memberMobileNo varchar(32),cardFaceNo varchar(64),pointAmountRate decimal(24,4),shiftId varchar(24),shiftNo varchar(32),shiftName varchar(64),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),couponId varchar(24),couponNo varchar(32),couponName varchar(32),couponLeastCost decimal(24,4),sourceSign varchar(32));
    """,

    ///订单优惠表
    """
    create table if not exists pos_order_promotion(id varchar(24)   not null unique,tenantId varchar(16)not null,orderId varchar(24),itemId varchar(24),tradeNo varchar(32),onlineFlag int,promotionType int,reason varchar(128),scheduleId varchar(24),scheduleSn varchar(24),promotionId varchar(24),promotionSn varchar(24),promotionMode varchar(8),scopeType varchar(8),promotionPlan varchar(64),price decimal(24,4),bargainPrice decimal(24,4),amount decimal(24,4),discountAmount decimal(24,4),receivableAmount decimal(24,4),discountRate decimal(24,4),enabled int,relationId int,couponId varchar(24),couponNo varchar(32),couponName varchar(128),finishDate varchar(24),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),sourceSign varchar(32));
    """,

    ///支持的打印机清单
    """
    create table if not exists pos_printer_brand(id varchar(24) not null,tenantId varchar(16),brandName varchar(32),dynamic varchar(32)default 通用打印模式,type int default(1),port varchar(64),pageWidth int,cutType varchar(16),dpi int,baudRate int,dataBit int,init varchar(64),doubleWidth varchar(64),cutPage varchar(64),doubleHeight varchar(64),normal varchar(64),doubleWidthHeight varchar(64),cashbox varchar(64),alignLeft varchar(64),alignCenter varchar(64),alignRight varchar(64),feed varchar(64),beep varchar(64),headerLines int default(0),footerLines int default(0),backLines int default(0),delay int default(1),userDefined int default(1),memo varchar(128),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createDate varchar(32),createUser varchar(16),modifyUser varchar(16),modifyDate varchar(32),primary key(id));
    """,

    ///初始化打印机数据
    """
    insert into pos_printer_brand (id, tenantId, brandName, dynamic, type, port, pageWidth, cutType, dpi, baudRate, dataBit, init, doubleWidth, cutPage, doubleHeight, normal, doubleWidthHeight, cashbox, alignLeft, alignCenter, alignRight, feed, beep, headerLines, footerLines, backLines, delay, userDefined, memo, ext1, ext2, ext3, createDate, createUser, modifyUser, modifyDate) VALUES 
    ('974570911539793919', '373001', '外置打印机', '通用打印模式', 1, 'USB,网口,蓝牙,串口', 80, '全切', 200, 9600, 8, '27,64', '27,33,32,28,33,4', '29,86,66', '27,33,16,28,33,8', '27,33,2,28,33,2', '27,33,48,28,33,12', '27,112,48,100,100', '27,97,48', '27,97,49', '27,97,50', '27,101,n', '27,66,3,1', 0, 0, 0, 1, 0, '', '', '', '', '2018-03-16 16:59:46', 'sync', '', ''),
    ('974570911539793920', '373001', '内置打印机', '通用打印模式', 1, '${PrinterConstant.getPrinterBrands()}', 80, '全切', 200, 9600, 8, '27,64', '27,33,32,28,33,4', '29,86,66', '27,33,16,28,33,8', '27,33,2,28,33,2', '27,33,48,28,33,12', '27,112,48,100,100', '27,97,48', '27,97,49', '27,97,50', '27,101,n', '27,66,3,1', 0, 0, 0, 1, 0, '', '', '', '', '2018-03-16 16:59:46', 'sync', '', '');
    """,

    ///打印机参数配置
    """
    create table if not exists pos_printer_item(id varchar(24)  not null,tenantId varchar(16),brandId varchar(24),brandName varchar(32),ticketType varchar(16),name varchar(64),dynamic varchar(32)default 通用打印模式,type int default(1),port varchar(16),portOrDriver int,pageWidth int,cutType varchar(16),beepType varchar(32),dpi int,serialPort varchar(16),baudRate int,dataBit int,parallelPort varchar(16),ipAddress varchar(64),vidpid varchar(64),driverName varchar(128),init varchar(64),doubleWidth varchar(64),cutPage varchar(64),doubleHeight varchar(64),normal varchar(64),doubleWidthHeight varchar(64),cashbox varchar(64),alignLeft varchar(64),alignCenter varchar(64),alignRight varchar(64),feed varchar(64),beep varchar(64),headerLines int default(0),footerLines int default(0),backLines int default(0),delay int default(1),rotation int default 0,userDefined int default(1),status int default(0),statusDesc varchar(128),memo varchar(128),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createDate varchar(32),createUser varchar(16),modifyUser varchar(16),modifyDate varchar(32),printBarcodeFlag int default 0,printQrcodeFlag int default 0,printBarcodeByImage int default 0,posNo varchar(16),primary key(id));
    """,

    ///打印小票表
    """
    create table if not exists pos_printer_ticket(id varchar(24)  not null,tenantId varchar(16)not null,printTicket varchar(32)not null,copies int(11)not null default '0',printerId varchar(24)not null,printerName varchar(32)not null,printerType varchar(32)default null,orderType varchar(64)default null,memo varchar(128)default null,ext1 varchar(32)default null,ext2 varchar(32)default null,ext3 varchar(32)default null,createDate varchar(32)default null,createUser varchar(16)default null,modifyUser varchar(16)default null,modifyDate varchar(32)default null,planId varchar(24),primary key(id));
    """,

    ///打印小票图片表
    """
    create table if not exists pos_print_img(id varchar(24)  primary key unique not null,tenantId varchar(16),storeId varchar(32),storeNo varchar(24),name varchar(32),type int,width int,height int,isEnable int,storageType int,storageAddress varchar(256),isDelete int,description varchar(128),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    """,

    ///门店信息表
    """
    create table if not exists pos_store_info(id varchar(24) not null,tenantId varchar(16)not null,code varchar(16)not null,name varchar(512)not null,type int not null,upOrg varchar(24),upOrgName varchar(512),askOrg varchar(24),askOrgName varchar(512),balanceRate int,postPrice int,addRate decimal(24,4),areaId varchar(24),areaPath varchar(128),status int,contacts varchar(32),tel varchar(16),mobile varchar(16),orderTel varchar(16),printName varchar(500),fax varchar(16),postcode varchar(16),address varchar(256),email varchar(64),acreage decimal(24,4),lng decimal(24,17),lat decimal(24,17),deleteFlag int default 0,width int,height int,storageType int,storageAddress varchar(256),authFlag int default 0,thirdNo varchar(16),creditAmount decimal(24,4),creditAmountUsed decimal(24,4),chargeLimit decimal(24,4),chargeLimitUsed decimal(24,4),defaultFlag int default 0,storePaySetting int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),warehouseId varchar(24),warehouseNo varchar(16),mallStart varchar(32),mallEnd varchar(32),mallBusinessFlag int,MallStroeFlag int,allowPurchase int,groupId varchar(24),groupNo varchar(32),primary key(id));
    """,

    ///班次表
    """
    create table if not exists pos_shift_log(id varchar(24) not null,tenantId varchar(16)not null,status integer default 0,storeId varchar(32)not null,storeNo varchar(16),workerId varchar(32)not null,workerNo varchar(32),workerName varchar(32),planId varchar(32),name varchar(64),`no` varchar(64),startTime varchar(32),firstDealTime varchar(32),endDealTime varchar(32),shiftTime varchar(32),posNo varchar(16)not null,acceptWorkerNo varchar(32),imprest decimal(24,4)default(0),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///支付核销表
    """
    create table if not exists pos_online_pay_log(id varchar(32) not null,tenantId varchar(16),storeId varchar(32),busType int,tradeNo varchar(32),payNo varchar(64),payAmount decimal(24,4),point decimal(24,4),pointAmountRate decimal(24,4),authCode varchar(32),password varchar(512),payChannel int,payTypeNo varchar(32),payTypeName varchar(64),voucheNo varchar(128),payStatus int,statusDesc varchar(64),quoteStatus int,quoteTradeNo varchar(32),quotePayNo varchar(64),shiftId varchar(24),shiftNo varchar(32),shiftName varchar(32),workerNo varchar(32),workerName varchar(64),quoteWorkerNo varchar(32),quoteWorkerName varchar(64),quoteDate varchar(32),posNo varchar(32),createUser varchar(64),createDate varchar(32),modifyUser varchar(64),modifyDate varchar(32));
    """,

    ///操作日志表
    """
    create table if not exists pos_log(id varchar(24) not null unique primary key,tenantId varchar(16)not null,storeNo varchar(24),posNo varchar(24),workerNo varchar(24),authNo varchar(24)not null,`action` varchar(64),module varchar(32),tradeNo varchar(32),productNo varchar(24),specId varchar(24),memo varchar(128),amount decimal(24,4),uploadStatus integer,serverId varchar(24),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32),storeId varchar(24),workerName varchar(64),productName varchar(512),specName varchar(32),storeName varchar(512),uploadErrors int,uploadMessage varchar(32));
    """,

    ///副屏图片表
    """
    create table if not exists pos_advert_picture(id varchar(24)  not null unique primary key,tenantId varchar(16)not null,orderNo int,width int,height int,name varchar(32),storageType varchar(64),storageAddress varchar(256),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    """,

    ///副屏字幕表
    """
    create table if not exists pos_advert_caption(id varchar(24)  not null unique primary key,tenantId varchar(16)not null,storeId varchar(24),name varchar(64),content varchar(256),isEnable int,orderNo int,isDelete int,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(16),createDate varchar(32),modifyUser varchar(16),modifyDate varchar(32));
    """,

    ///数据版本表
    """
    create table if not exists pos_data_version (id varchar(24) primary key unique not null, tenantId varchar(16) , name varchar(32) , dataType varchar(64) unique not null, version varchar(32) , isDownload integer default(0) not null, updateCount integer default(0) not null, isFinished integer default(0) not null, ext1 varchar(32) , ext2 varchar(32) , ext3 varchar(32) , createUser varchar(16) , createDate varchar(32) , modifyUser varchar(16) , modifyDate varchar(32));
    
    """,

    ///1.0.1版本新增部分
    ///做法分类表
    """
    create table if not exists pos_make_category(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,name varchar(32) ,type int default 0,isRadio int default 0,orderNo varchar(16) ,color varchar(64) ,deleteFlag int default 0,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///做法信息表
    """
    create table if not exists pos_make_info(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,categoryId varchar(24) ,description varchar(64) ,spell varchar(64) ,addPrice decimal(24,4) default(0),qtyFlag int default 0,orderNo varchar(16) ,color varchar(64) ,deleteFlag int default 0,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32),prvFlag int default 0);
    """,

    ///门店做法表
    """
    create table if not exists pos_store_make(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,storeId varchar(24) ,makeId varchar(24) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///商品做法表
    """
    create table if not exists pos_product_make(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,productId varchar(24) ,makeId varchar(24) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///桌台分类表
    """
    create table if not exists pos_store_table_type(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,name varchar(32) ,color varchar(16) ,deleteFlag int ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///桌台区域表
    """
    create table if not exists pos_store_table_area(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,name varchar(32) ,deleteFlag int ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///桌台信息表
    """
    create table if not exists pos_store_table(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,storeId varchar(32) ,areaId varchar(32) ,typeId varchar(32) ,no varchar(16) ,name varchar(32) ,number int ,deleteFlag int ,aliasName varchar(32) ,description varchar(64) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///厨显方案
    """
    create table if not exists pos_kds_plan(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,no varchar(16) ,name varchar(64) ,type varchar(8) ,description varchar(128) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///厨显商品
    """
    create table if not exists pos_kds_plan_product(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,storeId varchar(24) ,productId varchar(24) ,chuxianFlag int ,chuxian varchar(24) ,chuxianTime int ,chupinFlag int ,chupin varchar(24) ,chupinTime int ,labelFlag int ,labelValue varchar(24) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,

    ///门店商品表添加列
    """
    alter table pos_store_product add column mallFlag int default 0;
    """,

    ///1.0.2版本新增部分
    """
   alter table pos_order_promotion add column adjustAmount decimal(24,4) default 0;
    """,
    """
   alter table pos_order_item_promotion add column adjustAmount decimal(24,4) default 0;
    """,
    """
   alter table pos_authc add column activeCode text;
    """,
    """
    alter table pos_order add column refundStatus int default 0;
    """,

    ///1.0.3版本新增部分
    """
    create table if not exists pos_order_table(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,orderId varchar(24) ,tradeNo varchar(32) ,tableId varchar(24) ,tableNo varchar(16) ,tableName varchar(32) ,typeId varchar(24) ,typeNo varchar(16) ,typeName varchar(32) ,areaId varchar(24) ,areaNo varchar(16) ,areaName varchar(32) ,tableStatus int ,openTime varchar(24) ,openUser varchar(24) ,tableNumber int ,serialNo varchar(16) ,tableAction int ,people int default 1,excessFlag int ,totalAmount decimal(24,4) default(0),totalQuantity decimal(24,4) default(0),discountAmount decimal(24,4) default(0),totalRefund decimal(24,4) default(0),totalRefundAmount decimal(24,4) default(0),totalGive decimal(24,4) default(0),totalGiveAmount decimal(24,4) default(0),discountRate decimal(24,4) default(0),receivableAmount decimal(24,4) default(0),paidAmount decimal(24,4) default(0),malingAmount decimal(24,4) default(0),placeOrders int default(0),maxOrderNo int ,masterTable int ,perCapitaAmount decimal(24,4) default(0),posNo varchar(24) ,payNo varchar(32) ,finishDate varchar(32) ,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,
    """
    create table if not exists pos_order_temp(id varchar(32)  primary key not null unique,tenantId varchar(16) not null,storeId varchar(32) ,orderId varchar(32) ,tradeNo varchar(32) ,tableNo varchar(32) ,tableName varchar(64) ,paid decimal(24,4) default(0),totalQuantity decimal(24,4) default(0),workerNo varchar(32) ,workerName varchar(64) ,posNo varchar(16) ,saleDate varchar(24) ,orderJson text ,memo varchar(256) ,createUser varchar(32),createDate varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,
    """
    alter table pos_order add column `cashierAction` int default 0;
    """,
    """
    alter table pos_order add column `callNumber` varchar(16);
    """,
    """
    alter table pos_order add column `uploadNo` varchar(32);
    """,
    """
    alter table pos_order add column `makeStatus` int default 0;
    """,
    """
    alter table pos_order add column `makeFinishDate` varchar(32);
    """,
    """
    alter table pos_order add column `takeMealDate` varchar(32);
    """,
    """
    alter table pos_order add column `pointDealStatus` int default 0;
    """,
    """
    alter table pos_order add column `totalRefundQuantity` decimal(24,4) default 0;
    """,
    """
    alter table pos_order add column `totalRefundAmount` decimal(24,4) default 0;
    """,
    """
    alter table pos_order add column `totalGiftQuantity` decimal(24,4) default 0;
    """,
    """
    alter table pos_order add column `totalGiftAmount` decimal(24,4) default 0;
    """,
    """
    alter table pos_order add column `tableId` varchar(24);
    """,
    """
    alter table pos_order_item add column `orderRowStatus` int default 0;
    """,
    """
    alter table pos_order_item add column `tableId` varchar(24);
    """,
    """
    alter table pos_order_item add column `tableNo` varchar(16);
    """,
    """
    alter table pos_order_item add column `tableName` varchar(32);
    """,
    """
    alter table pos_order_item add column `tableBatchTag` varchar(32);
    """,
    """
    alter table pos_order_item add column `rreason` varchar(128);
    """,
    """
    alter table pos_order_item_make add column `tableId` varchar(24);
    """,
    """
    alter table pos_order_item_make add column `tableNo` varchar(16);
    """,
    """
    alter table pos_order_item_make add column `tableName` varchar(32);
    """,
    """
    alter table pos_order_item_promotion add column `tableId` varchar(24);
    """,
    """
    alter table pos_order_item_promotion add column `tableNo` varchar(16);
    """,
    """
    alter table pos_order_item_promotion add column `tableName` varchar(32);
    """,
    """
    alter table pos_order add column `orderUploadSource` int default 0;
    """,

    ///1.0.4版本没有数据库脚步变更
    ///1.0.5版本新增部分

    """
    insert into pos_urls (`id`, `tenantId`, `apiType`, `protocol`, `url`, `contextPath`, `userDefined`, `enable`, `memo`, `ext1`, `ext2`, `ext3`, `createUser`, `createDate`, `modifyUser`, `modifyDate`) VALUES ('874095336606535688', '373001', 'Meal', 'http', 'api.jwsaas.com', 'meal/api', 0, 1, '新零售', '', '', '', 'sync', '2020-09-12 10:00:00', 'sync', '2020-09-12 10:00:00');
    """,
    """
    insert into pos_urls (`id`, `tenantId`, `apiType`, `protocol`, `url`, `contextPath`, `userDefined`, `enable`, `memo`, `ext1`, `ext2`, `ext3`, `createUser`, `createDate`, `modifyUser`, `modifyDate`) VALUES ('874095336606535686', '373001', 'Transport', 'http', 'api.jwsaas.com', 'transport/api', 0, 1, '新零售', '', '', '', 'sync', '2020-08-01 09:00:00', 'sync', '2020-08-01 09:00:00');
    """,

    ///1.0.6版本新增部分

    """
    create table if not exists pos_shiftover_ticket(id varchar(24),tenantId varchar(16),`no` varchar(32),storeId varchar(32),storeNo varchar(32),storeName varchar(500),workId varchar(32),workNo varchar(32),workName varchar(64),shiftId varchar(24),shiftNo varchar(16),shiftName varchar(32),datetimeBegin varchar(32),firstDealTime varchar(32),endDealTime varchar(32),datetimeShift varchar(32),acceptWorkerNo varchar(32),posNo varchar(16),memo varchar(128),shiftAmount decimal(24,2)default 0,imprest decimal(24,2)default 0,shiftBlindFlag int default(0),handsMoney decimal(24,4)default(0),diffMoney decimal(24,4)default(0),deviceName varchar(64),deviceMac varchar(1024),deviceIp varchar(256),uploadStatus int default 0,uploadErrors int default 0,uploadCode varchar(32),uploadMessage varchar(128),uploadTime varchar(32),serverId varchar(32),ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createDate varchar(32),createUser varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,
    """
    create table if not exists pos_shiftover_ticket_cash(id varchar(24),tenantId varchar(16),ticketId varchar(24),storeId varchar(32),storeNo varchar(32),storeName varchar(500),shiftId varchar(24),shiftNo varchar(16),shiftName varchar(32),consumeCash decimal(24,4)default 0,consumeCashRefund decimal(24,4)default 0,cardRechargeCash decimal(24,4)default 0,cardCashRefund decimal(24,4)default 0,noTransCashIn decimal(24,4)default 0,noTransCashOut decimal(24,4)default 0,timesCashRecharge decimal(24,4)default 0,imprest decimal(24,4)default 0,totalCash decimal(24,4)default 0,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createDate varchar(32),createUser varchar(32),modifyUser varchar(32),modifyDate varchar(32),plusCashRecharge decimal(24,4));
    """,
    """
    create table if not exists pos_shiftover_ticket_pay(id varchar(24),tenantId varchar(16),ticketId varchar(24),storeId varchar(32),storeNo varchar(32),storeName varchar(500),shiftId varchar(24),shiftNo varchar(16),shiftName varchar(32),businessType varchar(32),payModeNo varchar(32),payModeName varchar(64),quantity int default 0,amount decimal(24,4)default 0,ext1 varchar(32),ext2 varchar(32),ext3 varchar(32),createDate varchar(32),createUser varchar(32),modifyUser varchar(32),modifyDate varchar(32));
    """,
  ];
}
