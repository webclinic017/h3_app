import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';
import 'package:package_info/package_info.dart';
import 'package:system_info/system_info.dart';

class DeviceUtils {
  static final DeviceUtils instance = DeviceUtils._();

  DeviceInfoPlugin deviceInfo;

  DeviceUtils._() {
    FLogger.debug("初始化DeviceUtils对象");
    deviceInfo = new DeviceInfoPlugin();
  }

  Future<String> getMode() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.machine;
    }
  }

  Future<String> getIpAddress() async {
    String ipAddress = "127.0.0.1";
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = '127.0.0.1';
    }

    return Future.value(ipAddress);
  }

  Future<String> getSystemVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.version.release;
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.systemVersion;
    }
  }

  Future<String> getSerialId() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    var array = packageInfo.version.split(".");
    return "${array[0]}.${array[1]}.${array[2]}";
  }

  Future<String> getAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  String getKernelName() {
    String result = "";
    try {
      result = "${SysInfo.kernelName} ${SysInfo.kernelVersion}";
    } catch (e) {
      FLogger.error("获取系统内核及版本异常");
    }

    return result;
  }

  int getProcessors() {
    int result = 0;
    try {
      var processors = SysInfo.processors;
      result = processors.length;
    } catch (e) {
      FLogger.error("获取CPU核数异常");
    }

    return result;
  }

  String getTotalPhysicalMemory() {
    String result = "";
    try {
      result = "${SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024)}";
    } catch (e) {
      FLogger.error("获取系统物理内存异常");
    }
    return result;
  }

  String getFreePhysicalMemory() {
    String result = "";
    try {
      result = "${SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024)}";
    } catch (e) {
      FLogger.error("获取系统可用内存异常");
    }
    return result;
  }
}
