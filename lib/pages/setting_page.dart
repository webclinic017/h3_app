import 'package:flutter/material.dart';
import 'package:h3_app/constants.dart';
import '../cashier_vertcal_tabs.dart';
import '../global.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘
      backgroundColor: Constants.hexStringToColor("#D2D2D2"),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment
                .bottomCenter, // 10% of the width, so there are ten blinds.
            colors: [
              Constants.hexStringToColor("#4AB3FD"),
              Constants.hexStringToColor("#F7F7F7")
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: Constants.paddingAll(0),
            decoration: BoxDecoration(
              color: Constants.hexStringToColor("#D2D2D2"),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: Constants.paddingAll(0),
                  height: Constants.getAdapterHeight(90.0),
                  decoration: BoxDecoration(
                    color: Constants.hexStringToColor("#FFFFFF"),
                    border: Border(
                        bottom: BorderSide(
                            color: Constants.hexStringToColor("#F2F2F2"),
                            width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        // onTap: () => NavigatorUtils.instance.goBack(context),
                        child: SizedBox(
                          width: Constants.getAdapterWidth(90),
                          height: double.infinity,
                          child: Icon(Icons.arrow_back_ios,
                              size: Constants.getAdapterWidth(48),
                              color: Constants.hexStringToColor("#2B2B2B")),
                        ),
                      ),
                      Text(
                        "参数设置",
                        style: TextStyles.getTextStyle(
                            color: Constants.hexStringToColor("#383838"),
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CashierVerticalTabs(
                    initialIndex: 0,
                    tabsWidth: Constants.getAdapterWidth(180),
                    tabsHeight: Constants.getAdapterHeight(90),
                    backgroundColor: Constants.hexStringToColor("#FFFFFF"),
                    tabBackgroundColor: Constants.hexStringToColor("#FFFFFF"),
                    selectedTabBackgroundColor:
                        Constants.hexStringToColor("#D2D2D2"),
                    tabsShadowColor: Constants.hexStringToColor("#D2D2D2"),
                    indicatorColor: Colors.green,
                    disabledChangePageFromContentView: true,
                    changePageDuration: const Duration(milliseconds: 5),
                    tabTextStyle: TextStyles.getTextStyle(
                        color: Constants.hexStringToColor("#91939C"),
                        fontSize: 28),
                    tabTextAlignment: TabTextAlignment.center,
                    selectedTabTextStyle: TextStyles.getTextStyle(
                        color: Constants.hexStringToColor("#333333"),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                    // header: buildHeaderBar(),
                    // expandTabs: ExpandTabs(tabsWidth: Constants.getAdapterWidth(70)),
                    tabs: <TabItem>[
                      //TabItem("收银参数"),
                      TabItem("打印设置", icon: null),
                      TabItem("点单助手", icon: null),
                      TabItem("抹零设置", icon: null),
                    ],
                    contents: <Widget>[
                      // Container(),
                      // PrinterPage(),
                      // AssistantParameter(),
                      // MalingPage(),
                    ],
                  ),
                ),
                // Container(
                //   height: Constants.getAdapterHeight(120.0),
                //   decoration: BoxDecoration(
                //     color: Constants.hexStringToColor("#FFFFFF"),
                //     border: Border(
                //         top: BorderSide(
                //             color: Constants.hexStringToColor("#F2F2F2"),
                //             width: 1)),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
