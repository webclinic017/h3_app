import 'package:h3_app/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'i18n_en_US.dart';
import 'i18n_zh_CN.dart';
import 'i18n_zh_TW.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _sentences;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  ///采用Dart文件代替JSON，去除加载JSON的操作，避免黑屏
  Future<bool> load() async {
    switch (locale.toString()) {
      case "en_US":
        _sentences = en_US;
        break;
      case "zh_CN":
        _sentences = zh_CN;
        break;
      case "zh_TW":
        _sentences = zh_TW;
        break;
      default:
        _sentences = zh_CN;
    }
    return true;
  }

  String _translate(String key) {
    return _sentences[key];
  }

  //多语言变量定义
  ///应用名称
  String get appTitle => _translate('app-title');

  ///注册页面-标题
  String get registerPageTitle => _translate("register-page-title");
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocalCodes.contains(locale.toString());
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocalCodes.contains(locale.toString());
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return DefaultCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}
