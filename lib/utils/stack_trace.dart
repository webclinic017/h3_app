import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

class FlutterChain {
  FlutterChain._();

  static void capture<T>(
    T callback(), {
    void onError(error, Chain chain),
    bool simple: true,
  }) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
      var isolateError = pair as List<dynamic>;
      var _error = isolateError.first;
      var _stackTrace = isolateError.last;
      Zone.current.handleUncaughtError(_error, _stackTrace);
    }).sendPort);
    runZoned(
      () {
        FlutterError.onError = (FlutterErrorDetails details) async {
          Zone.current.handleUncaughtError(details.exception, details.stack);
        };
        callback();
      },
      onError: (_error, _stack) {
        printError(_error, _stack, simple: simple);
      },
    );
  }

  static printError(_error, _stack, {bool simple: true}) {
    debugLog(_error.toString(), isShowTime: false, showLine: true);
    String errorStr = "";
    if (simple) {
      errorStr = _parseFlutterStack(Trace.from(_stack));
    } else {
      errorStr = Trace.from(_stack).toString();
    }
    if (errorStr.isNotEmpty)
      debugLog(errorStr, isShowTime: false, showLine: true);
  }

  static String _parseFlutterStack(Trace _trace) {
    String result = "";
    String _traceStr = _trace.toString();
    List<String> _strs = _traceStr.split("\n");
    _strs.forEach((_str) {
      if (!_str.contains("package:flutter/") &&
          !_str.contains("dart:") &&
          !_str.contains("package:flutter_stack_trace/")) {
        if (_str.isNotEmpty) {
          if (result.isNotEmpty)
            result = "$result\n$_str";
          else
            result = _str;
        }
      }
    });
    return result;
  }
}

void debugLog(Object obj, {bool isShowTime = true, bool showLine = false}) {
  bool isDebug = false;
  assert(isDebug = true);
  if (isDebug) {
    String log = isShowTime
        ? "${DateTime.now()}:  ${obj.toString()}"
        : "${obj.toString()}";
    if (showLine) {
      var logSlice = log.split("\n");
      int maxLength = _getMaxLength(logSlice) + 3;
      String line = "-";
      for (int i = 0; i < maxLength + 1; i++) {
        line = "$line-";
      }
      debugPrint(line);
      logSlice.forEach((_log) {
        if (_log.isEmpty) {
          return;
        }
        int gapLength = maxLength - _log.length;
        if (gapLength > 0) {
          String space = " ";
          for (int i = 0; i < gapLength - 3; i++) {
            space = "$space ";
          }
          debugPrint("| $_log$space |");
        }
      });
      debugPrint(line);
    } else {
      debugPrint(log);
    }
  }
}

int _getMaxLength(List<String> logSlice) {
  List<int> lengthList = <int>[];
  logSlice.forEach((_log) {
    lengthList.add(_log.length);
  });
  lengthList.sort((left, right) => right - left);
  return lengthList[0];
}
