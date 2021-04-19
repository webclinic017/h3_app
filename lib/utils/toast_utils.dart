import 'package:h3_app/constants.dart';
import 'package:h3_app/enums/notify_type.dart';
import 'package:h3_app/global.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

/// Toast工具类
class ToastUtils {
  static ToastFuture notify(
    String msg, {
    NotifyType type = NotifyType.info,
    double width = 120,
    double height = 110,
  }) {
    var imgName = "assets/notify/icon_notify_info.png";
    if (type == NotifyType.error) {
      imgName = "assets/notify/icon_notify_error.png";
    } else if (type == NotifyType.done) {
      imgName = "assets/notify/icon_notify_done.png";
    }

    var widget = Center(
      child: Container(
        padding: Constants.paddingAll(10),
        decoration: ShapeDecoration(
          color: Colors.black.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.asset(imgName,
                width: Constants.getAdapterWidth(64),
                height: Constants.getAdapterHeight(64)),
            Text("$msg", style: TextStyles.getTextStyle(color: Colors.white)),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );

    return showToastWidget(widget);
  }

  static show(
    String msg, {
    ToastPosition position,
    TextStyle textStyle,
    EdgeInsetsGeometry textPadding,
    Color backgroundColor,
    VoidCallback onDismiss,
    double radius = 13,
    int milliseconds = 2000,
  }) {
    if (msg == null) {
      return;
    }
    showToast(
      msg,
      radius: radius,
      position: position ?? ToastPosition.center,
      backgroundColor: backgroundColor ?? Colors.black.withOpacity(0.8),
      textStyle: textStyle ??
          TextStyles.getTextStyle(color: Colors.white, fontSize: 32),
      textPadding: textPadding,
      duration: Duration(milliseconds: milliseconds),
      onDismiss: onDismiss,
      dismissOtherToast: true,
    );
  }

  static cancelToast() {
    dismissAllToast();
  }
}
