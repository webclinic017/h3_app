import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class MemberTimesCountProject {
  /// 项目ID
  String projectId = "";

  /// 项目编号
  String projectNo = "";

  /// 项目名称
  String projectName = "";

  /// 剩余次数
  int remainCount = 0;

  MemberTimesCountProject();

  factory MemberTimesCountProject.fromJson(Map<String, dynamic> json) {
    return MemberTimesCountProject()
      ..projectId = Convert.toStr(json['projectId'])
      ..projectName = Convert.toStr(json['projectName'])
      ..projectNo = Convert.toStr(json['projectNo'])
      ..remainCount = Convert.toInt(json['remainCount']);
  }

  static List<MemberTimesCountProject> toList(
      List<Map<String, dynamic>> lists) {
    var result = new List<MemberTimesCountProject>();
    lists.forEach((map) => result.add(MemberTimesCountProject.fromJson(map)));
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['projectNo'] = this.projectNo;
    data['remainCount'] = this.remainCount;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
