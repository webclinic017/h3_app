import 'package:h3_app/blocs/register_bloc.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/i18n/i18n.dart';
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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ///激活码焦点
  final FocusNode _activeCodeFocus = FocusNode();
  final TextEditingController _activeCodeController = TextEditingController();

  ///硬件设备注册逻辑
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();

    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    assert(_registerBloc != null);

    // Subscribe
    KeyboardVisibility.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    assert(local != null);

    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: new Text(
            "产品授权",
            style: TextStyles.getTextStyle(
                color: Constants.hexStringToColor("#FFFFFF"), fontSize: 48),
          ),
          centerTitle: true,
        ),
        body: BlocListener(
          cubit: this._registerBloc,
          listener: (context, state) {
            if (state.status == RegisterStatus.Loading) {
              EasyLoading.show(status: "激活码校验中...");
            } else if (state.status == RegisterStatus.Failure) {
              //显示错误提示，1秒后自动关闭
              EasyLoading.showError("${state.message}",
                  duration: Duration(seconds: 3));
            } else if (state.status == RegisterStatus.Confirm) {
              //关闭提示框
              EasyLoading.dismiss();

              Future.delayed(Duration(milliseconds: 100)).then((e) {
                var title = "授权信息确认";
                var info =
                    "门店编号：${state.registrationCode.storeNo}\n\n门店名称：${state.registrationCode.storeName}";
                DialogUtils.confirm(context, title, info, () {
                  _registerBloc.add(ActiveSuccessful());
                }, () {
                  FLogger.warn("用户放弃激活操作");
                }, width: 500);
              });
            } else if (state.status == RegisterStatus.Waiting) {
              EasyLoading.show(status: "请稍候,激活中...");
            } else if (state.status == RegisterStatus.Success) {
              //关闭提示框
              EasyLoading.dismiss();

              Future.delayed(Duration(milliseconds: 100)).then((e) {
                NavigatorUtils.instance
                    .push(context, RouterManager.LOGIN_PAGE, replace: true);
              });
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            cubit: this._registerBloc,
            builder: (context, state) {
              return Container(
                padding: Constants.paddingAll(0),
                decoration: BoxDecoration(
                  color: Constants.hexStringToColor("#FFFFFF"),
                ),
                child: Container(
                  padding: Constants.paddingOnly(left: 50, right: 50, top: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "${local.registerPageTitle}",
                          style: TextStyles.getTextStyle(
                              color: Constants.hexStringToColor("#7A73C7"),
                              fontSize: 48),
                        ),
                      ),
                      Space(height: Constants.getAdapterHeight(18)),
                      Center(
                        child: Text(
                          "本操作需要手机连接Internet网络",
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
                        child: _buildActiveCodeTextField(context, state),
                      ),
                      Space(height: Constants.getAdapterHeight(40)),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: Constants.getAdapterHeight(80),
                            maxWidth: Constants.getAdapterWidth(720)),
                        child: ProgressButton(
                          defaultWidget: Text(
                            "立即激活",
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
                                  _registerBloc.add(Submitted());
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

  Widget _buildActiveCodeTextField(BuildContext context, RegisterState state) {
    return TextFormField(
      autofocus: true,
      focusNode: this._activeCodeFocus,
      controller: this._activeCodeController,
      enabled: true,
      style: TextStyles.getTextStyle(fontSize: 32),
      decoration: InputDecoration(
        contentPadding: Constants.paddingOnly(top: 20, left: 32, bottom: 20),
        hintText: "请输入激活码",
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
        this._registerBloc.add(ActiveCodeChanged(activeCode: inputValue));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    //释放激活码资源
    this._activeCodeController.dispose();
    this._activeCodeFocus.dispose();
  }
}
