import 'package:h3_app/constants.dart';
import 'package:h3_app/widgets/space.dart';
import 'package:flutter/material.dart';
import 'widgets/load_image.dart';

enum IndicatorSide { start, end }

enum TabTextAlignment { left, center, right }

class TabItem {
  final String text;
  final String icon;
  final String format;
  final Widget child;
  TabItem(this.text, {@required this.icon, this.format: 'png', this.child});
}

class CashierVerticalTabs extends StatefulWidget {
  final Key key;
  final int initialIndex;
  final double tabsWidth;
  final double tabsHeight; //zhangy 2020-02-19 Add 添加TabItem宽度
  final double indicatorWidth;
  final IndicatorSide indicatorSide;
  final List<TabItem> tabs;
  final List<Widget> contents;
  final TextDirection direction;
  final Color indicatorColor;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color selectedTabBackgroundColor;
  final Color tabBackgroundColor;
  final TextStyle selectedTabTextStyle;
  final TextStyle tabTextStyle;
  final TabTextAlignment tabTextAlignment; //zhangy 2020-02-22 Add
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function(int tabIndex) onSelect;
  final Color backgroundColor;
  final Widget header; //zhangy 2020-02-24 Add 添加contents页面顶部组件
  final Widget footer; //zhangy 2020-02-24 Add 添加contents页面底部组件
  final Widget expandTabs; //zhangy 2020-02-24 Add 添加TabItem集合的扩展项目，底部对齐
  CashierVerticalTabs({
    this.key,
    @required this.tabs,
    @required this.contents,
    this.tabsWidth = 70,
    this.tabsHeight = 80,
    this.indicatorWidth = 3,
    this.indicatorSide,
    this.initialIndex = 0,
    this.direction = TextDirection.ltr,
    this.indicatorColor = Colors.green,
    this.disabledChangePageFromContentView = false,
    this.contentScrollAxis = Axis.horizontal,
    this.selectedTabBackgroundColor = const Color(0x1100ff00),
    this.tabBackgroundColor = const Color(0xfff8f8f8),
    this.selectedTabTextStyle = const TextStyle(color: Colors.black),
    this.tabTextStyle = const TextStyle(color: Colors.black38),
    this.tabTextAlignment = TabTextAlignment.center,
    this.changePageCurve = Curves.easeInOut,
    this.changePageDuration = const Duration(milliseconds: 300),
    this.tabsShadowColor = Colors.black54,
    this.tabsElevation = 20.0,
    this.onSelect,
    this.backgroundColor,
    this.header,
    this.footer,
    this.expandTabs,
  })  : assert(
            tabs != null && contents != null && tabs.length == contents.length
  ),
        super(key: key);

  @override
  _CashierVerticalTabs createState() => _CashierVerticalTabs();
}

class _CashierVerticalTabs extends State<CashierVerticalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex;
  bool _changePageByTapView;

  AnimationController animationController;
  Animation<double> animation;
  Animation<RelativeRect> rectAnimation;

  PageController pageController = PageController();

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 50),
        vsync: this,
      ));
    }
    _selectTab(widget.initialIndex);

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.initialIndex);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Container(
        color: widget.backgroundColor ?? Theme.of(context).canvasColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Material(
                    child: Container(
                      width: widget.tabsWidth,
                      color: widget.tabBackgroundColor,
                      //把Tabs的显示方式区分为上下两部分
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemExtent: widget
                                  .tabsHeight, //zhangy 2020-02-19 Add 左侧高度
                              itemCount: widget.tabs.length,
                              itemBuilder: (context, index) {
                                TabItem tab = widget.tabs[index];

                                //zhangy 2020-02-22 Edit 添加对齐属性
                                Alignment alignment = Alignment.center;
                                CrossAxisAlignment crossAxisAlignment =
                                    CrossAxisAlignment.center;
                                if (widget.tabTextAlignment ==
                                    TabTextAlignment.left) {
                                  alignment = Alignment.centerLeft;
                                  crossAxisAlignment = CrossAxisAlignment.start;
                                } else if (widget.tabTextAlignment ==
                                    TabTextAlignment.right) {
                                  alignment = Alignment.centerRight;
                                  crossAxisAlignment = CrossAxisAlignment.end;
                                }

                                Widget child;
                                if (tab.child != null) {
                                  child = tab.child;
                                } else {
                                  //zhangy 2020-02-22 Edit 修改对齐方式和选中后字体及图标颜色
                                  child = Container(
                                      padding: Constants.paddingAll(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment: crossAxisAlignment,
                                        children: <Widget>[
                                          (tab.icon != null)
                                              ? Column(children: <Widget>[
                                                  LoadAssetImage(tab.icon,
                                                      format: tab.format,
                                                      color: _selectedIndex == index
                                                          ? widget
                                                              .selectedTabTextStyle
                                                              .color
                                                          : widget.tabTextStyle
                                                              .color,
                                                      width: Constants
                                                          .getAdapterWidth(30),
                                                      height: Constants
                                                          .getAdapterHeight(
                                                              30)),
                                                  Space(
                                                      height: Constants
                                                          .getAdapterHeight(8))
                                                ])
                                              : Container(),
                                          (tab
                                                      .text !=
                                                  null)
                                              ? Container(
                                                  alignment: alignment,
                                                  width: widget.tabsWidth,
                                                  child: Text(
                                                      tab.text,
                                                      softWrap: true,
                                                      style: _selectedIndex ==
                                                              index
                                                          ? widget
                                                              .selectedTabTextStyle
                                                          : widget
                                                              .tabTextStyle))
                                              : Container(),
                                        ],
                                      ));
                                }

                                Color itemBGColor = widget.tabBackgroundColor;
                                if (_selectedIndex == index)
                                  itemBGColor =
                                      widget.selectedTabBackgroundColor;

                                double left, right;
                                if (widget.direction == TextDirection.rtl) {
                                  left = (widget.indicatorSide ==
                                          IndicatorSide.end)
                                      ? 0
                                      : null;
                                  right = (widget.indicatorSide ==
                                          IndicatorSide.start)
                                      ? 0
                                      : null;
                                } else {
                                  left = (widget.indicatorSide ==
                                          IndicatorSide.start)
                                      ? 0
                                      : null;
                                  right = (widget.indicatorSide ==
                                          IndicatorSide.end)
                                      ? 0
                                      : null;
                                }

                                return Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      width: widget.indicatorWidth,
                                      left: left,
                                      right: right,
                                      child: ScaleTransition(
                                        child: Container(
                                          color: widget.indicatorColor,
                                        ),
                                        scale:
                                            Tween(begin: 0.0, end: 1.0).animate(
                                          new CurvedAnimation(
                                            parent: animationControllers[index],
                                            curve: Curves.elasticOut,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _changePageByTapView = true;
                                        setState(() {
                                          _selectTab(index);
                                        });

                                        pageController.animateToPage(index,
                                            duration: widget.changePageDuration,
                                            curve: widget.changePageCurve);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: itemBGColor,
                                          //zhangy 2020-02-24 Add 添加TabItem下划线
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color:
                                                      widget.tabsShadowColor)),
                                        ),
                                        alignment: alignment,
                                        padding: Constants.paddingAll(0),
                                        child: child,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          widget.expandTabs != null
                              ? widget.expandTabs
                              : Container(),
                        ],
                      ),
                    ),
                    elevation: widget.tabsElevation,
                    shadowColor: widget.tabsShadowColor,
                    shape: BeveledRectangleBorder(),
                  ),

                  //zhangy 2020-02-24 Edit 修改contents页面显示方式
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        //顶部内容
                        widget.header != null ? widget.header : Container(),
                        Expanded(
                          child: PageView.builder(
                            scrollDirection: widget.contentScrollAxis,
                            physics: pageScrollPhysics,
                            onPageChanged: (index) {
                              if (_changePageByTapView == false ||
                                  _changePageByTapView == null) {
                                _selectTab(index);
                              }
                              if (_selectedIndex == index) {
                                _changePageByTapView = null;
                              }
                              setState(() {});
                            },
                            controller: pageController,

                            // the number of pages
                            itemCount: widget.contents.length,

                            // building pages
                            itemBuilder: (BuildContext context, int index) {
                              return widget.contents[index];
                            },
                          ),
                        ),
                        //底部内容
                        widget.footer != null ? widget.footer : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTab(index) {
    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();

    if (widget.onSelect != null) {
      widget.onSelect(_selectedIndex);
    }
  }
}
