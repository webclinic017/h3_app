// TODO Implement this library.
//
//
//
//
import 'dart:convert';
import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:h3_app/callbacks.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/pos_worker.dart';
import 'package:h3_app/entity/pos_worker_module.dart';
import 'package:h3_app/entity/pos_worker_role.dart';
import 'package:h3_app/enums/module_key_code.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/keyboards/keyboard.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_object.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/toast_utils.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:h3_app/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

import 'api_utils.dart';
import 'des_utils.dart';
import 'http_utils.dart';

class AuthDialogPage extends StatefulWidget {
  // 订单对象
  final OrderObject orderObject;

  //标识是否需要校验
  final String permissionCode;

  //期望的折扣率
  final double discountRate;

  //期望的免单额
  final double freeAmount;

  //授权的功能
  final ModuleKeyCode moduleKeyCode;

  //授权
  final PermissionAction onAction;

  //关闭
  final OnCloseCallback onClose;

  AuthDialogPage(this.moduleKeyCode,
      {this.orderObject,
      this.permissionCode = Constants.PERMISSION_CODE,
      this.discountRate = double.maxFinite,
      this.freeAmount = double.maxFinite,
      this.onAction,
      this.onClose});

  @override
  State<StatefulWidget> createState() => _AuthDialogPageState();
}

class _AuthDialogPageState extends State<AuthDialogPage>
    with SingleTickerProviderStateMixin {
  ///操作员工号
  final FocusNode _workerNoFocus = FocusNode();
  final TextEditingController _workerNoController = TextEditingController();

  ///操作员密码
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();

  //键盘功能的业务逻辑处理
  KeyboardBloc _keyboardBloc;

  @override
  void initState() {
    super.initState();

    _keyboardBloc = BlocProvider.of<KeyboardBloc>(context);
    assert(this._keyboardBloc != null);

    //1.注册键盘
    NumberKeyboard.register(
        buttonWidth: 130, buttonHeight: 120, buttonSpace: 10);
    //2.初始化键盘
    KeyboardManager.init(context, this._keyboardBloc);

    WidgetsBinding.instance.addPostFrameCallback((callback) {});
  }

  @override
  void dispose() {
    super.dispose();

    //释放工号资源
    this._workerNoController.dispose();
    this._workerNoFocus.dispose();
    //释放密码资源
    this._passwordController.dispose();
    this._passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: Constants.paddingAll(0),
        child: Column(
          children: <Widget>[
            ///顶部标题
            _buildHeader(),

            ///中部操作区
            _buildContent(),
          ],
        ),
      ),
    );
  }

  ///构建内容区域
  Widget _buildContent() {
    return Container(
      padding: Constants.paddingLTRB(40, 20, 40, 30),
      height: Constants.getAdapterHeight(640),
      width: double.infinity,
      color: Constants.hexStringToColor("#F0F0F0"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: Constants.getAdapterHeight(75),
                maxWidth: Constants.getAdapterWidth(600)),
            child: _buildWorkerNoTextField(),
          ),
          Space(height: Constants.getAdapterHeight(20)),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: Constants.getAdapterHeight(75),
                maxWidth: Constants.getAdapterWidth(600)),
            child: _buildPasswordTextField(),
          ),
          Space(height: Constants.getAdapterHeight(20)),
          Expanded(
            child: Container(
              child: BlocBuilder<KeyboardBloc, KeyboardState>(
                cubit: this._keyboardBloc,
                buildWhen: (previousState, currentState) {
                  return true;
                },
                builder: (context, state) {
                  return state.keyboard == null
                      ? Container()
                      : state.keyboard.builder(context, state.controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerNoTextField() {
    return TextFormField(
      enabled: true,
      autofocus: true,
      focusNode: this._workerNoFocus,
      controller: this._workerNoController,
      style: TextStyles.getTextStyle(fontSize: 28),
      decoration: InputDecoration(
        contentPadding: Constants.paddingOnly(top: 20, left: 32, bottom: 0),
        hintText: "输入授权人工号",
        hintStyle: TextStyles.getTextStyle(
            color: Constants.hexStringToColor("#999999"), fontSize: 28),
        filled: true,
        fillColor: Constants.hexStringToColor("#FFFFFF"),
        //prefixIcon: LoadAssetImage("login/icon3", format: "png", width: Constants.getAdapterWidth(30), height: Constants.getAdapterHeight(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#E0E0E0"), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#7A73C7"), width: 1),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12) //限制长度
      ],
      keyboardType: NumberKeyboard.inputType,
      textInputAction: TextInputAction.newline,
      maxLines: 1,
      enableInteractiveSelection: true, //长按复制 剪切
      autocorrect: false,
      onFieldSubmitted: (inputValue) async {
        var valid = _validateInputValue();
        if (valid) {
          await login();
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      enabled: true,
      autofocus: false,
      obscureText: true,
      focusNode: this._passwordFocus,
      controller: this._passwordController,
      style: TextStyles.getTextStyle(fontSize: 28),
      decoration: InputDecoration(
        contentPadding: Constants.paddingOnly(top: 20, left: 32, bottom: 0),
        hintText: "输入授权人密码",
        hintStyle: TextStyles.getTextStyle(
            color: Constants.hexStringToColor("#999999"), fontSize: 28),
        filled: true,
        fillColor: Constants.hexStringToColor("#FFFFFF"),
        //prefixIcon: LoadAssetImage("login/icon4", format: "png", width: Constants.getAdapterWidth(30), height: Constants.getAdapterHeight(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#E0E0E0"), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#7A73C7"), width: 1),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12) //限制长度
      ],
      keyboardType: NumberKeyboard.inputType,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      enableInteractiveSelection: true, //长按复制 剪切
      autocorrect: false,
      onFieldSubmitted: (inputValue) async {
        var valid = _validateInputValue();
        if (valid) {
          await login();
        }
      },
    );
  }

  Future<void> login() async {
    try {
      ToastUtils.show("权限校验中...", milliseconds: 2000);

      var workerNo = this._workerNoController.text.trim();
      var passwd = this._passwordController.text.trim();
      var loginResult =
          await AuthzUtils.instance.databaseLogin(workerNo, passwd);

      if (loginResult.item1) {
        var permission =
            await AuthzUtils.instance.getPermission(loginResult.item3);
        var checkPermission = AuthzUtils.instance.checkPermission(
            widget.permissionCode,
            permission,
            widget.discountRate,
            widget.freeAmount);

        ToastUtils.show("${checkPermission.item2}");

        //有权限
        if (checkPermission.item1) {
          if (widget.onAction != null) {
            widget.onAction(permission);
          }
        } else {
          ToastUtils.show("${checkPermission.item2}");
        }
      } else {
        ToastUtils.show("${loginResult.item2}");
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("收银员云端登录异常:" + e.toString());
    } finally {
      //ToastUtils.cancelToast();
    }
  }

  bool _validateInputValue() {
    String workerNo = _workerNoController.text.trim();
    if (StringUtils.isBlank(workerNo)) {
      ToastUtils.show("工号不能为空,请输入...");
      FocusScope.of(context).requestFocus(_workerNoFocus);
      return false;
    }

    String passwd = _passwordController.text.trim();
    if (StringUtils.isBlank(passwd)) {
      ToastUtils.show("密码不能为空,请输入...");
      FocusScope.of(context).requestFocus(_passwordFocus);
      return false;
    }

    FocusScope.of(context).requestFocus(_passwordFocus);

    return true;
  }

  ///构建顶部标题栏
  Widget _buildHeader() {
    return Container(
      height: Constants.getAdapterHeight(90.0),
      decoration: BoxDecoration(
        color: Constants.hexStringToColor("#7A73C7"),
        border:
            Border.all(width: 0, color: Constants.hexStringToColor("#7A73C7")),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: Constants.paddingOnly(left: 15),
              alignment: Alignment.centerLeft,
              child: Text("授权[${widget.moduleKeyCode.name}]",
                  style: TextStyles.getTextStyle(
                      color: Constants.hexStringToColor("#FFFFFF"),
                      fontSize: 32)),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.onClose != null) {
                widget.onClose();
              }
            },
            child: Padding(
              padding: Constants.paddingSymmetric(horizontal: 15),
              child: Icon(CommunityMaterialIcons.close_box,
                  color: Constants.hexStringToColor("#FFFFFF"),
                  size: Constants.getAdapterWidth(56)),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthzUtils {
  // 工厂模式
  factory AuthzUtils() => _getInstance();
  static AuthzUtils get instance => _getInstance();
  static AuthzUtils _instance;

  static AuthzUtils _getInstance() {
    if (_instance == null) {
      _instance = new AuthzUtils._internal();
    }
    return _instance;
  }

  AuthzUtils._internal();

  Tuple2<bool, String> checkAuthz(
      BuildContext context,
      ModuleKeyCode moduleKeyCode,
      String permissionCode,
      OrderObject orderObject,
      PermissionAction action,
      {double expectDiscountRate = double.maxFinite,
      double expectFreeAmount = double.maxFinite}) {
    bool isAuthz = true;
    String message = "权限校验成功";
    //有权限
    if (hasPermission(permissionCode)) {
      //最大折扣率
      var discountRate = Global.instance.worker.maxDiscountRate;
      //最高免单额
      var freeAmount = Global.instance.worker.maxFreeAmount;
      //权限列表
      var permission = Global.instance.worker.permission;

      var authz =
          Tuple4(discountRate, freeAmount, permission, Global.instance.worker);
      var checkPermission = AuthzUtils.instance.checkPermission(
          permissionCode, authz, expectDiscountRate, expectFreeAmount);

      //有权限
      if (checkPermission.item1) {
        action(new Tuple4(
            discountRate, freeAmount, permission, Global.instance.worker));
      } else {
        YYDialog dialog;
        var onClose = () {
          dialog?.dismiss();
        };
        var onAction = (args) {
          action(args);
          dialog?.dismiss();
        };
        var authDialogPage = AuthDialogPage(
          moduleKeyCode,
          orderObject: orderObject,
          permissionCode: permissionCode,
          discountRate: expectDiscountRate,
          freeAmount: expectFreeAmount,
          onAction: onAction,
          onClose: onClose,
        );

        dialog = _openAuthzDialog(context, authDialogPage, moduleKeyCode,
            permissionCode, orderObject, action,
            expectDiscountRate: expectDiscountRate,
            expectFreeAmount: expectFreeAmount);
      }
    } else {
      YYDialog dialog;
      var onClose = () {
        dialog?.dismiss();
      };
      var onAction = (args) {
        action(args);
        dialog?.dismiss();
      };
      var authDialogPage = AuthDialogPage(
        moduleKeyCode,
        orderObject: orderObject,
        permissionCode: permissionCode,
        discountRate: expectDiscountRate,
        freeAmount: expectFreeAmount,
        onAction: onAction,
        onClose: onClose,
      );
      dialog = _openAuthzDialog(context, authDialogPage, moduleKeyCode,
          permissionCode, orderObject, action,
          expectDiscountRate: expectDiscountRate,
          expectFreeAmount: expectFreeAmount);
    }
    return Tuple2<bool, String>(isAuthz, message);
  }

  YYDialog _openAuthzDialog(
      BuildContext context,
      Widget child,
      ModuleKeyCode moduleKeyCode,
      String permissionCode,
      OrderObject orderObject,
      PermissionAction action,
      {double expectDiscountRate = double.maxFinite,
      double expectFreeAmount = double.maxFinite}) {
    return YYDialog().build(context)
      ..width = Constants.getAdapterWidth(640)
      ..height = Constants.getAdapterHeight(800)
      ..margin = Constants.paddingAll(0)
      ..borderRadius = 0.0
      ..backgroundColor = Colors.transparent
      ..barrierColor = Constants.hexStringToColor("#000000").withOpacity(0.3)
      ..barrierDismissible = false
      ..widget(child)
      ..show();
  }

  Tuple2<bool, String> checkPermission(
      String permissionCode,
      Tuple4<double, double, List<String>, Worker> permission,
      double discountRate,
      double freeAmount) {
    bool result = true;
    String message = "授权成功";

    //功能权限不校验或者校验并拥有
    bool isPermission = (permissionCode == Constants.PERMISSION_CODE ||
        permission.item3.contains(permissionCode));

    if (result && !isPermission) {
      result = false;
      message = "授权人[${permission.item4.no}]没有该权限";
    }

    //如果有功能权限,校验折扣数据权限
    if (result && discountRate != double.maxFinite) {
      bool isDiscountRate =
          (0 == discountRate || permission.item1 <= discountRate);
      if (!isDiscountRate) {
        result = false;
        message = "授权人[${permission.item4.no}]折扣权限不足";
      }
    }

    //如果有功能和折扣数据权限,校验免单数据权限
    if (result && freeAmount != double.maxFinite) {
      bool isFreeAmount = permission.item2 >= freeAmount;
      if (!isFreeAmount) {
        result = false;
        message = "授权人[${permission.item4.no}]免单权限不足";
      }
    }

    return Tuple2(result, message);
  }

  bool hasPermission(String moduleNo) {
    if (StringUtils.isBlank(moduleNo)) {
      return false;
    }
    return Global.instance.worker != null &&
        Global.instance.worker.permission != null &&
        Global.instance.worker.permission.contains(moduleNo);
  }

  Future<Tuple3<bool, String, Worker>> databaseLogin(
      String workerNo, String passwd) async {
    bool result = false;
    String msg = "";
    Worker worker;
    try {
      String sql = "select * from pos_worker where `no` = '$workerNo';";
      var database = await SqlUtils.instance.open();
      var lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        worker = Worker.fromMap(lists[0]);
      }

      if (worker != null) {
        var isCorrect =
            await FlutterBcrypt.verify(password: passwd, hash: worker.passwd);
        if (isCorrect) {
          result = true;
          msg = "登录认证通过";
        } else {
          result = false;
          msg = "工号或者密码错误";
          worker = null;
        }
      } else {
        result = false;
        msg = "工号不存在";
        worker = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("收银员本地登录发生异常:" + e.toString());

      result = false;
      msg = "登录验证异常";
      worker = null;
    }
    return Tuple3<bool, String, Worker>(result, msg, worker);
  }

  Future<Tuple3<bool, String, Worker>> httpLogin(
      String workerNo, String passwd) async {
    bool result = false;
    String msg = "";
    Worker worker;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "worker.login";

      String password = DesUtils.encrypt(passwd);
      var data = {
        "storeId": Global.instance.authc?.storeId,
        "posNo": Global.instance.authc?.posNo,
        "workerNo": workerNo,
        "passwd": password,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      print("@@@@@@@@@@@@@@@@>>>>>$response");

      result = response.success;
      msg = response.msg;
      if (result) {
        worker = Worker.fromMap(response.data);

        result = true;
        msg = "收银员联机认证成功";
      } else {
        result = false;
        msg = "收银员联机认证失败";
        worker = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("收银员联机登录异常:" + e.toString());

      result = false;
      msg = "收银员联机登录出错了";
      worker = null;
    }
    return Tuple3<bool, String, Worker>(result, msg, worker);
  }

  Future<Tuple4<double, double, List<String>, Worker>> getPermission(
      Worker worker) async {
    //最大折扣
    double maxDiscountRate = 100;
    //最高免单
    double maxFreeAmount = 0;
    //权限模块
    var permission = new List<String>();
    try {
      if (worker != null) {
        String sql =
            "select * from pos_worker_role where userId = '${worker.id}';";
        var database = await SqlUtils.instance.open();
        List<Map<String, dynamic>> lists = await database.rawQuery(sql);
        List<WorkerRole> roles;
        if (lists != null && lists.length > 0) {
          roles = WorkerRole.toList(lists);
        }

        if (roles == null) {
          roles = new List<WorkerRole>();
        }

        sql = "select * from pos_worker_module where userId = '${worker.id}';";
        lists = await database.rawQuery(sql);
        List<WorkerModule> modules;
        if (lists != null && lists.length > 0) {
          modules = WorkerModule.toList(lists);
        }
        if (modules == null) {
          modules = new List<WorkerModule>();
        }
        modules.forEach((item) {
          permission.add(item.moduleNo);
        });

        if (worker.discount == -1) {
          //-1取角色
          if (roles.length > 0) {
            maxDiscountRate = roles.map((e) => e.discount).reduce(min);
          } else {
            //参数设置有问题，系统默认不打折
            maxDiscountRate = 100;
          }
        } else {
          //取员工设置
          maxDiscountRate = worker.discount;
        }

        //免单金额
        if (worker.freeAmount == -1) {
          //-1取角色
          if (roles.length > 0) {
            maxFreeAmount = roles.map((e) => e.freeAmount).reduce(max);
          } else {
            //参数设置有问题，系统默认不打折
            maxFreeAmount = 0;
          }
        } else {
          //取员工设置
          maxFreeAmount = worker.freeAmount;
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("加载操作员权限数据异常:" + e.toString());
    }

    print(
        "收银员<${worker.no}>,最大折扣<$maxDiscountRate>,最大免单<$maxFreeAmount>,权限<${permission.toString()}>");

    return Tuple4(maxDiscountRate, maxFreeAmount, permission, worker);
  }
}
