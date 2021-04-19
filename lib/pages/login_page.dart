import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/routers/navigator_utils.dart';
import 'package:h3_app/routers/router_manager.dart';
import 'package:h3_app/utils/image_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/widgets/space.dart';
import '../constants.dart';
import 'package:h3_app/widgets/load_image.dart';
import 'package:h3_app/widgets/progress_button.dart';
import 'package:h3_app/pages/setting_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    await SqlUtils.instance.open();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        decoration: BoxDecoration(
          color: Constants.hexStringToColor("#FFFFFF"),
          image: DecorationImage(
              image: AssetImage(
                  ImageUtils.getImgPath("login/background", format: "jpg")),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          body: SafeArea(child: Builder(builder: (context) {
            return Container(
              padding: Constants.paddingAll(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: Constants.paddingLTRB(10, 5, 10, 5),
                    height: Constants.getAdapterHeight(60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text('ss',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 24)),
                                Space(
                                  width: Constants.getAdapterWidth(20),
                                ),
                                Container(
                                  padding: Constants.paddingAll(0),
                                  width: Constants.getAdapterWidth(90),
                                  height: Constants.getAdapterHeight(30),
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: Text(
                                    '试用版',
                                    style: TextStyles.getTextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 24,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                              right: Radius.circular(0),
                            ),
                            border: Border(
                                bottom: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => SettingPage()));
                              NavigatorUtils.instance
                                  .push(context, RouterManager.SYS_INIT_PAGE);
                            },
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CommunityMaterialIcons.cog_outline,
                                  size: Constants.getAdapterWidth(48),
                                  color: Colors.grey[500],
                                )),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    padding: Constants.paddingLTRB(80, 10, 80, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: LoadAssetImage('brand_logo',
                              format: 'png',
                              height: Constants.getAdapterHeight(58),
                              width: Constants.getAdapterWidth(200),
                              fit: BoxFit.fill),
                        ),
                        Space(height: Constants.getAdapterHeight(20)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: Constants.getAdapterHeight(80),
                              maxWidth: Constants.getAdapterWidth(720)),
                          child: _buildStoreNoTextField(),
                        ),
                        Space(height: Constants.getAdapterHeight(20)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: Constants.getAdapterHeight(80),
                              maxWidth: Constants.getAdapterWidth(720)),
                          child: _buildStoreNameTextField(),
                        ),
                        Space(height: Constants.getAdapterHeight(20)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: Constants.getAdapterHeight(80),
                              maxWidth: Constants.getAdapterWidth(720)),
                          child: _buildWorkerNoTextField(),
                        ),
                        Space(height: Constants.getAdapterHeight(20)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: Constants.getAdapterHeight(80),
                              maxWidth: Constants.getAdapterWidth(720)),
                          child: _buildPasswordTextField(),
                        ),
                        Space(
                          height: Constants.getAdapterHeight(30),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: Constants.getAdapterHeight(80),
                            maxWidth: Constants.getAdapterWidth(720),
                          ),
                          child: ProgressButton(
                            defaultWidget: Text(
                              '登录',
                              style: TextStyles.getTextStyle(
                                  fontSize: 32,
                                  color: Constants.hexStringToColor('#FFFFFF')),
                            ),
                            color: Constants.hexStringToColor('#7A73C7'),
                            width: double.infinity,
                            height: Constants.getAdapterHeight(80),
                            borderRadius: Constants.getAdapterHeight(40),
                            animate: true,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
        ),
      ),
    );
  }

  Widget _buildWorkerNoTextField() {
    return TextField(
      enabled: true,
      autofocus: false,
      // focusNode: this._workerNoFocus,
      // controller: this._workerNoController,
      style: TextStyle(fontSize: Constants.getAdapterFontSize(32)),
      decoration: InputDecoration(
        contentPadding: Constants.paddingOnly(top: 20, left: 20, bottom: 20),
        hintText: "输入操作员工号",
        hintStyle: TextStyles.getTextStyle(
            color: Constants.hexStringToColor("#999999"), fontSize: 32),
        filled: true,
        fillColor: Constants.hexStringToColor("#FFFFFF"),
        prefixIcon: LoadAssetImage("login/icon3",
            format: "png",
            width: Constants.getAdapterWidth(30),
            height: Constants.getAdapterHeight(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#E0E0E0"), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(
              color: Constants.hexStringToColor("#7A73C7"), width: 1),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12) //限制长度
      ],
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      enableInteractiveSelection: true, //长按复制 剪切
      autocorrect: false,
      onChanged: (inputValue) async {
        // this._loginBloc.add(WorkerNoChanged(workerNo: inputValue));
      },
    );
  }
}

Widget _buildPasswordTextField() {
  return TextFormField(
    enabled: true,
    autofocus: false,
    obscureText: true,
    // focusNode: this._passwordFocus,
    // controller: this._passwordController,
    style: TextStyles.getTextStyle(fontSize: 32),
    decoration: InputDecoration(
      contentPadding: Constants.paddingOnly(top: 20, left: 20, bottom: 20),
      hintText: "输入操作员密码",
      hintStyle: TextStyles.getTextStyle(
          color: Constants.hexStringToColor("#999999"), fontSize: 32),
      filled: true,
      fillColor: Constants.hexStringToColor("#FFFFFF"),
      prefixIcon: LoadAssetImage("login/icon4",
          format: "png",
          width: Constants.getAdapterWidth(34),
          height: Constants.getAdapterHeight(34)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide:
            BorderSide(color: Constants.hexStringToColor("#E0E0E0"), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide:
            BorderSide(color: Constants.hexStringToColor("#7A73C7"), width: 1),
      ),
    ),
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(12) //限制长度
    ],
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.done,
    maxLines: 1,
    enableInteractiveSelection: true, //长按复制 剪切
    autocorrect: false,
    onChanged: (inputValue) async {
      // this._loginBloc.add(PasswordChanged(password: inputValue));
    },
  );
}

Widget _buildStoreNoTextField() {
  return TextFormField(
    enabled: false,
    autofocus: false,
    style: TextStyles.getTextStyle(fontSize: 32),
    // initialValue: Global.instance.authc?.storeNo,
    decoration: InputDecoration(
      contentPadding: Constants.paddingOnly(top: 20, left: 20, bottom: 20),
      hintText: "",
      hintStyle: TextStyles.getTextStyle(
          color: Constants.hexStringToColor("#999999"), fontSize: 24),
      filled: true,
      fillColor: Constants.hexStringToColor("#FFFFFF"),
      prefixIcon: LoadAssetImage("login/icon2",
          format: "png",
          width: Constants.getAdapterWidth(30),
          height: Constants.getAdapterHeight(30),
          fit: BoxFit.none),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide:
            BorderSide(color: Constants.hexStringToColor("#E0E0E0"), width: 1),
      ),
    ),
  );
}

Widget _buildStoreNameTextField() {
  return TextFormField(
    enabled: false,
    autofocus: false,
    style: TextStyles.getTextStyle(fontSize: 32),
    // initialValue: Global.instance.authc?.storeName,
    decoration: InputDecoration(
      contentPadding: Constants.paddingOnly(top: 20, left: 20, bottom: 20),
      hintText: "",
      hintStyle: TextStyles.getTextStyle(
          color: Constants.hexStringToColor("#999999"), fontSize: 24),
      filled: true,
      fillColor: Constants.hexStringToColor("#FFFFFF"),
      prefixIcon: LoadAssetImage("login/icon1",
          format: "png",
          width: Constants.getAdapterWidth(30),
          height: Constants.getAdapterHeight(30),
          fit: BoxFit.none),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide:
            BorderSide(color: Constants.hexStringToColor("#E0E0E0"), width: 1),
      ),
    ),
  );
}
