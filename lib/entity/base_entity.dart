import 'package:equatable/equatable.dart';
import 'package:h3_app/utils/date_utils.dart';

abstract class BaseEntity extends Equatable {
  ///主键ID
  String id;

  ///租户ID
  String tenantId;

  ///扩展字段1
  String ext1;

  ///扩展字段2
  String ext2;

  ///扩展字段3
  String ext3;

  ///创建人
  String createUser;

  ///创建日期
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///修改人
  String modifyUser;

  ///修改日期
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  @override
  List<Object> get props => [];
}
