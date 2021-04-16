class VersionObject {
  /// 应用标识
  String appSign = "";

  /// 应用名称
  String appName = "";

  /// 终端类型
  String terminalType = "";

  /// 版本类型
  int versionType = 0;

  /// 当前程序版本号
  String versionNum = "";

  /// 当前最新程序版本号
  String newVersionNum = "";

  /// 升级最低版本
  String minVersionNum = "";

  /// 是否有新版本
  bool hasNew = false;

  /// 自动更新后启动的主程序文件
  String startApplication = "";

  /// 文件名
  String fileName = "";

  /// 文件大小(单位:字节)
  int length = 0;

  /// MD5校验值
  String checkNum = "";

  /// 更新日志
  String uploadLog = "";

  /// 是否强制升级(1-是,0-否)
  int forceUpload = 0;

  /// 备注说明
  String description = "";

  /// 下载地址
  String url = "";

  /// 文件路径
  String uploadFile = "";
}
