import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  PermissionUtils._();

  static Future<PermissionStatus> hasPermission(
      BuildContext context, Permission permission) async {
    try {
      final PermissionStatus status = await permission.status;

//      if ([PermissionStatus.undetermined, PermissionStatus.denied].contains(status)) {
//        Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
//
//        if (statuses[Permission.storage] == PermissionStatus.granted) {
//          _getContactData();
//        }
//      } else if (status == PermissionStatus.granted) {
//        _getContactData();
//      }

      return new Future.value(status);
    } on PlatformException catch (e) {
      print('Exception ' + e.toString());
    }
    return new Future.value(PermissionStatus.denied);
  }

  //系统启动必备的基础权限
  static Future<List<SystemPermission>> requiredPermission(
      BuildContext context) async {
    var result = new List<SystemPermission>();
    //存储权限
    final PermissionStatus storageStatus = await Permission.storage.status;
    result.add(new SystemPermission(
        "存储权限",
        new Icon(Icons.storage),
        Permission.storage,
        storageStatus,
        storageStatus == PermissionStatus.granted));

    //位置权限
    if (Platform.isAndroid) {
      final PermissionStatus locationStatus = await Permission.location.status;
      result.add(new SystemPermission(
          "位置权限",
          new Icon(Icons.location_on),
          Permission.location,
          locationStatus,
          locationStatus == PermissionStatus.granted));

      //相机权限
      final PermissionStatus cameraStatus = await Permission.camera.status;
      result.add(new SystemPermission(
          "相机权限",
          new Icon(Icons.camera),
          Permission.camera,
          cameraStatus,
          cameraStatus == PermissionStatus.granted));
    }

    // if (Platform.isIOS) {
    //   final PermissionStatus locationStatus = await Permission.locationWhenInUse.status;
    //   result.add(new SystemPermission("位置权限", new Icon(Icons.location_on), Permission.locationWhenInUse, locationStatus, locationStatus == PermissionStatus.granted));
    // }

    return new Future.value(result);
  }

  static requestPermission(List<Permission> permissions,
      {onAllOk(), onDenied(Permission permission)}) async {
    await permissions.request().then((Map<Permission, PermissionStatus> maps) {
      bool isAllGranted = true;
      maps.forEach((Permission permission, PermissionStatus status) async {
        switch (status) {
          case PermissionStatus.granted:
            print("PermissionUtils: granted" + permission.toString());
            break;
          case PermissionStatus.denied:
            isAllGranted = false;
            print("PermissionUtils: denied" + permission.toString());
            if (onDenied != null) {
              onDenied(permission);
            }
            break;
          case PermissionStatus.restricted:
            isAllGranted = false;

            ///only ios
            print("PermissionUtils: restricted: " + permission.toString());

            break;
          case PermissionStatus.permanentlyDenied:
            isAllGranted = false;

            ///only android
            print(
                "PermissionUtils: permanentlyDenied: " + permission.toString());

            break;
          case PermissionStatus.undetermined:
            print("PermissionUtils: undetermined" + permission.toString());
            break;
          case PermissionStatus.limited:
            break;
        }
      });
      if (isAllGranted) {
        if (onAllOk != null) {
          onAllOk();
        }
      }
    });
  }
}

class SystemPermission {
  //权限提示文字
  String title;
  //权限图标
  Icon icon;
  //系统权限
  Permission perm;
  //授权状态
  PermissionStatus status;
  //是否选择
  bool checked;

  SystemPermission(this.title, this.icon, this.perm, this.status, this.checked);

  ///依赖的系统权限
  static List<SystemPermission> toList() {
    var result = new List<SystemPermission>();

    result.add(new SystemPermission("存储权限", new Icon(Icons.storage),
        Permission.storage, PermissionStatus.undetermined, false));
    result.add(new SystemPermission("位置权限", new Icon(Icons.location_on),
        Permission.location, PermissionStatus.undetermined, false));
    result.add(new SystemPermission("相机权限", new Icon(Icons.camera),
        Permission.camera, PermissionStatus.undetermined, false));
    result.add(new SystemPermission("电话权限", new Icon(Icons.phone),
        Permission.phone, PermissionStatus.undetermined, false));

    return result;
  }
}
