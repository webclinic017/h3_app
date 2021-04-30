import 'package:h3_app/blocs/sys_init_bloc.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/routers/navigator_utils.dart';
import 'package:h3_app/routers/router_manager.dart';
import 'package:h3_app/utils/dialog_utils.dart';
import 'package:h3_app/widgets/progress_button.dart';
import 'package:h3_app/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SysInitPage extends StatefulWidget {
  @override
  _SysInitPageState createState() => _SysInitPageState();
}

class _SysInitPageState extends State<SysInitPage>
    with SingleTickerProviderStateMixin {
  ///激活码焦点
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  //业务逻辑处理
  SysInitBloc _sysInitBloc;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _sysInitBloc = BlocProvider.of<SysInitBloc>(context);
    assert(this._sysInitBloc != null);

    this._sysInitBloc.add(LoadDataEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  void dispose() {
    super.dispose();

    this._focus.dispose();
    this._controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomPadding: false, //输入框抵住键盘
        backgroundColor: Constants.hexStringToColor("#656472"),
        appBar: AppBar(
          title: new Text(
            "系统初始化",
            style: TextStyles.getTextStyle(
                color: Constants.hexStringToColor("#FFFFFF"), fontSize: 48),
          ),
          centerTitle: true,
        ),
        body: BlocListener<SysInitBloc, SysInitState>(
          cubit: this._sysInitBloc,
          listener: (context, state) {
            if (state.status == SysInitStatus.Loading) {
              EasyLoading.show(status: "安全码校验中...");
            } else if (state.status == SysInitStatus.Failure) {
              //显示错误提示，1秒后自动关闭
              EasyLoading.showError("${state.message}",
                  duration: Duration(seconds: 3));
            } else if (state.status == SysInitStatus.Confirm) {
              //关闭提示框
              EasyLoading.dismiss();

              Future.delayed(Duration(milliseconds: 100)).then((e) {
                var title = "清除数据确认";
                var info = "请再次确认初始化操作,数据清除后不可恢复,确认吗?";
                DialogUtils.confirm(context, title, info, () {
                  FLogger.warn("用户确认清除数据");
                  _sysInitBloc.add(Successful());
                }, () {
                  FLogger.warn("用户放弃激活操作");
                }, width: 600);
              });
            } else if (state.status == SysInitStatus.Waiting) {
              EasyLoading.show(status: "请稍候,校验中...");
            } else if (state.status == SysInitStatus.Success) {
              //关闭提示框
              EasyLoading.dismiss();

              Future.delayed(Duration(milliseconds: 100)).then((e) {
                NavigatorUtils.instance.push(
                    // context, RouterManager.REGISTER_PAGE,
                    context,
                    RouterManager.LOGIN_PAGE,
                    replace: true,
                    clearStack: true);
              });
            }
          },
          child: BlocBuilder<SysInitBloc, SysInitState>(
            cubit: this._sysInitBloc,
            buildWhen: (previousState, currentState) {
              return true;
            },
            builder: (context, state) {
              return Container(
                padding: Constants.paddingAll(0),
                decoration: BoxDecoration(
                  color: Constants.hexStringToColor("#FFFFFF"),
                ),
                child: Container(
                  padding: Constants.paddingOnly(left: 50, right: 50, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "企业编码:${state.authc?.tenantId}",
                                style: TextStyles.getTextStyle(
                                    color:
                                        Constants.hexStringToColor("#333333"),
                                    fontSize: 32),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "门店编码:${state.authc?.storeNo}",
                                style: TextStyles.getTextStyle(
                                    color:
                                        Constants.hexStringToColor("#333333"),
                                    fontSize: 32),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Space(height: Constants.getAdapterHeight(18)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "POS编码:${state.authc?.posNo}",
                                style: TextStyles.getTextStyle(
                                    color:
                                        Constants.hexStringToColor("#333333"),
                                    fontSize: 32),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "门店名称:${state.authc?.storeName}",
                                style: TextStyles.getTextStyle(
                                  color: Constants.hexStringToColor("#333333"),
                                  fontSize: 32,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Space(height: Constants.getAdapterHeight(30)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "本操作将彻底清除本地数据，请谨慎操作",
                          style: TextStyles.getTextStyle(
                              color: Constants.hexStringToColor("#FF8159"),
                              fontSize: 32),
                        ),
                      ),
                      Space(height: Constants.getAdapterHeight(30)),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: Constants.getAdapterHeight(80),
                          maxWidth: Constants.getAdapterWidth(720),
                        ),
                        child: _buildSafeCodeTextField(context, state),
                      ),
                      Space(height: Constants.getAdapterHeight(40)),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: Constants.getAdapterHeight(80),
                            maxWidth: Constants.getAdapterWidth(720)),
                        child: ProgressButton(
                          defaultWidget: Text(
                            "立即初始化",
                            style: TextStyles.getTextStyle(
                                fontSize: 32,
                                color: Constants.hexStringToColor("#FFFFFF")),
                          ),
                          color: Constants.hexStringToColor("#7A73C7"),
                          width: double.infinity,
                          height: Constants.getAdapterHeight(80),
                          borderRadius: Constants.getAdapterHeight(40),
                          animate: true,
                          onPressed: state.isValid
                              ? () {
                                  _sysInitBloc.add(Submitted());
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSafeCodeTextField(BuildContext context, SysInitState state) {
    return TextFormField(
      autofocus: true,
      obscureText: true,
      focusNode: this._focus,
      controller: this._controller,
      enabled: true,
      style: TextStyles.getTextStyle(fontSize: 32),
      decoration: InputDecoration(
        contentPadding: Constants.paddingOnly(top: 20, left: 32, bottom: 20),
        hintText: "请输入安全码",
        hintStyle: TextStyles.getTextStyle(
            color: Constants.hexStringToColor("#999999"), fontSize: 32),
        filled: true,
        fillColor: Constants.hexStringToColor("#FFFFFF"),
      ),

      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(14) //限制长度
      ],
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      enableInteractiveSelection: true, //长按复制剪切
      autocorrect: false,
      onChanged: (inputValue) {
        //发送激活码文本变动事件
        this._sysInitBloc.add(SafeCodeChanged(safeCode: inputValue));
      },
    );
  }
}
