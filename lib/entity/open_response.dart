import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';

class OpenResponse {
  ///状态码,0-成功，其他表示失败
  int code = -1;

  ///返回消息内容
  String msg = "";

  ///返回的数据内容
  dynamic data;

  OpenResponse(this.code, this.msg, this.data);

  bool get success => this.code == 0;

  @override
  String toString() {
    return '''OpenResponse {
      success: $success,
      code: $code,
      msg: $msg,
      data: $data,
    }''';
  }

  ///解析服务端返回的分页数据,返回:集合
  static List<Map<String, dynamic>> parseListResponse(dynamic data) {
    List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();

    try {
      ///获取列表数据
      if (data is List<Map<String, dynamic>>) {
        list = List<Map<String, dynamic>>.from(data);
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("解析分页数据异常:" + e.toString());
    }
    return list;
  }

  ///解析服务端返回的分页数据,返回:集合、总页数、当前页码、每页大小、总记录
  static Tuple5<List<Map<String, dynamic>>, int, int, int, int>
      parsePagerResponse(Map<String, dynamic> data) {
    List<Map<String, dynamic>> list;
    int pageCount;
    int pageNumber;
    int pageSize;
    int totalCount;

    try {
      ///获取列表数据
      list = data.containsKey("list")
          ? List<Map<String, dynamic>>.from(data["list"])
          : new List<Map<String, dynamic>>();

      ///获取总页数
      pageCount =
          data.containsKey("pageCount") ? Convert.toInt(data["pageCount"]) : 0;

      ///获取当前页码
      pageNumber = data.containsKey("pageNumber")
          ? Convert.toInt(data["pageNumber"])
          : 0;

      ///获取每页数量
      pageSize =
          data.containsKey("pageSize") ? Convert.toInt(data["pageSize"]) : 0;

      ///获取总条数
      totalCount = data.containsKey("totalCount")
          ? Convert.toInt(data["totalCount"])
          : 0;
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("解析分页数据异常:" + e.toString());
    }
    return Tuple5<List<Map<String, dynamic>>, int, int, int, int>(
        list, pageCount, pageNumber, pageSize, totalCount);
  }
}
