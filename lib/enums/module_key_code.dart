class ModuleKeyCode {
  final String name;
  final String value;
  final String permissionCode;

  const ModuleKeyCode._(this.name, this.value, {this.permissionCode = ""});

  static const $_0 = ModuleKeyCode._("None", "0");
  static const $_1 = ModuleKeyCode._("收银模块", "1");
  static const $_2 = ModuleKeyCode._("外卖模块", "2");
  static const $_3 = ModuleKeyCode._("促销模块", "3");
  static const $_4 = ModuleKeyCode._("会员模块", "4");
  static const $_5 = ModuleKeyCode._("预约模块", "5");
  static const $_6 = ModuleKeyCode._("库存模块", "6");
  static const $_7 = ModuleKeyCode._("报表模块", "7");
  static const $_8 = ModuleKeyCode._("设置模块", "8");
  static const $_9 = ModuleKeyCode._("关于模块", "9");
  static const $_10 = ModuleKeyCode._("帮助模块", "10");
  static const $_11 = ModuleKeyCode._("采购模块", "11");
  static const $_101 = ModuleKeyCode._("结账", "101", permissionCode: "10004");
  static const $_104 = ModuleKeyCode._("数量", "104");
  static const $_105 = ModuleKeyCode._("数量加", "105", permissionCode: "10004");
  static const $_106 = ModuleKeyCode._("数量减", "106", permissionCode: "10005");
  static const $_107 = ModuleKeyCode._("改价", "107");
  static const $_108 = ModuleKeyCode._("折扣", "108");
  static const $_109 = ModuleKeyCode._("删除单品", "109");
  static const $_110 = ModuleKeyCode._("赠送", "110");
  static const $_111 = ModuleKeyCode._("做法", "111");
  static const $_112 = ModuleKeyCode._("规格", "112");
  static const $_113 = ModuleKeyCode._("换菜", "113");
  static const $_114 = ModuleKeyCode._("取消全单", "114");
  static const $_115 = ModuleKeyCode._("会员", "115", permissionCode: "10009");
  static const $_116 = ModuleKeyCode._("导购", "116");
  static const $_117 = ModuleKeyCode._("整单议价", "117", permissionCode: "10015");
  static const $_118 = ModuleKeyCode._("整单折扣", "118", permissionCode: "10014");
  static const $_119 = ModuleKeyCode._("挂单", "119");
  static const $_120 = ModuleKeyCode._("取单", "120");
  static const $_121 = ModuleKeyCode._("交班", "121");
  static const $_122 = ModuleKeyCode._("退货", "122", permissionCode: "10019");
  static const $_123 = ModuleKeyCode._("锁屏", "123");
  static const $_124 = ModuleKeyCode._("清零", "124");
  static const $_125 = ModuleKeyCode._("去皮", "125");
  static const $_126 = ModuleKeyCode._("凑整", "126");
  static const $_127 = ModuleKeyCode._("寄存", "127");
  static const $_128 = ModuleKeyCode._("开钱箱", "128");
  static const $_129 = ModuleKeyCode._("连续称重", "129");
  static const $_130 = ModuleKeyCode._("会员卡开户", "130");
  static const $_131 = ModuleKeyCode._("会员卡充值", "131");
  static const $_132 = ModuleKeyCode._("会员卡退卡", "132");
  static const $_133 = ModuleKeyCode._("会员卡冻结", "133");
  static const $_134 = ModuleKeyCode._("会员卡解冻", "134");
  static const $_135 = ModuleKeyCode._("会员卡充值消费记录", "135");
  static const $_136 = ModuleKeyCode._("会员卡挂失", "136");
  static const $_137 = ModuleKeyCode._("会员卡解挂", "137");
  static const $_138 = ModuleKeyCode._("会员信息修改", "138");
  static const $_139 = ModuleKeyCode._("计次充值", "139");
  static const $_140 = ModuleKeyCode._("计次消费", "140");
  static const $_141 = ModuleKeyCode._("会员管理", "141");
  static const $_142 = ModuleKeyCode._("兑换礼品", "142");
  static const $_143 = ModuleKeyCode._("兑换储值", "143");
  static const $_144 = ModuleKeyCode._("会员报表", "144");
  static const $_145 = ModuleKeyCode._("积分变动查询", "145");
  static const $_146 = ModuleKeyCode._("积分兑换查询", "146");
  static const $_147 = ModuleKeyCode._("积分调整", "147");
  static const $_148 = ModuleKeyCode._("会员卡换卡", "148");
  static const $_149 = ModuleKeyCode._("会员修改密码", "149");
  static const $_150 = ModuleKeyCode._("销售流水", "150");
  static const $_151 = ModuleKeyCode._("营业日报", "151");
  static const $_152 = ModuleKeyCode._("收款流水", "152");
  static const $_153 = ModuleKeyCode._("商品销售流水", "153");
  static const $_154 = ModuleKeyCode._("商品销售汇总", "154");
  static const $_155 = ModuleKeyCode._("交班记录", "155");
  static const $_156 = ModuleKeyCode._("寄存报表", "156");
  static const $_157 = ModuleKeyCode._("错充处理", "157");
  static const $_158 = ModuleKeyCode._("桌号", "158");
  static const $_159 = ModuleKeyCode._("连续开关", "159");
  static const $_160 = ModuleKeyCode._("重新写卡", "160");
  static const $_161 = ModuleKeyCode._("会员折扣券", "161");
  static const $_162 = ModuleKeyCode._("购买PLUS会员", "162");
  static const $_163 = ModuleKeyCode._("删除挂单", "163");
  static const $_164 = ModuleKeyCode._("业务菜单", "164");
  static const $_165 = ModuleKeyCode._("会员卡小额充值", "165");
  static const $_166 = ModuleKeyCode._("异常支付", "166");
  static const $_167 = ModuleKeyCode._("礼品卡销售", "167");
  static const $_200 = ModuleKeyCode._("要货单", "200");
  static const $_201 = ModuleKeyCode._("总部统配收货", "201");
  static const $_202 = ModuleKeyCode._("统配收货差异", "202");
  static const $_203 = ModuleKeyCode._("商品调回总部", "203");
  static const $_204 = ModuleKeyCode._("店间直调申请", "204");
  static const $_205 = ModuleKeyCode._("店间直调发货", "205");
  static const $_206 = ModuleKeyCode._("店间直调收货", "206");
  static const $_207 = ModuleKeyCode._("店间直调差异", "207");
  static const $_208 = ModuleKeyCode._("店间直调退货", "208");
  static const $_209 = ModuleKeyCode._("其他出库", "209");
  static const $_210 = ModuleKeyCode._("其他入库", "210");
  static const $_211 = ModuleKeyCode._("要货汇总", "211");
  static const $_212 = ModuleKeyCode._("配送明细", "212");
  static const $_213 = ModuleKeyCode._("配送汇总", "213");
  static const $_214 = ModuleKeyCode._("商品调回申请", "214");
  static const $_215 = ModuleKeyCode._("店间退货申请", "215");
  static const $_230 = ModuleKeyCode._("采购订单", "230");
  static const $_231 = ModuleKeyCode._("采购入库", "231");
  static const $_232 = ModuleKeyCode._("采购退货", "232");
  static const $_233 = ModuleKeyCode._("促销进价单", "233");
  static const $_234 = ModuleKeyCode._("采购明细", "234");
  static const $_235 = ModuleKeyCode._("采购汇总", "235");
  static const $_236 = ModuleKeyCode._("联营账款单", "236");
  static const $_237 = ModuleKeyCode._("代销账款单", "237");
  static const $_238 = ModuleKeyCode._("扣率代销账款单", "238");
  static const $_239 = ModuleKeyCode._("供应商费用单", "239");
  static const $_240 = ModuleKeyCode._("供应商预付款单", "240");
  static const $_241 = ModuleKeyCode._("供应商结算单", "241");
  static const $_242 = ModuleKeyCode._("供应商往来账款", "242");
  static const $_243 = ModuleKeyCode._("联营销售查询", "243");
  static const $_244 = ModuleKeyCode._("代销销售查询", "244");
  static const $_245 = ModuleKeyCode._("扣率代销销售查询", "245");
  static const $_246 = ModuleKeyCode._("促销补差单", "246");
  static const $_260 = ModuleKeyCode._("盘点号申请", "260");
  static const $_261 = ModuleKeyCode._("商品盘点单", "261");
  static const $_262 = ModuleKeyCode._("盘点差异处理", "262");
  static const $_263 = ModuleKeyCode._("盘点明细", "263");
  static const $_264 = ModuleKeyCode._("漏盘商品", "264");
  static const $_265 = ModuleKeyCode._("盘点差异", "265");
  static const $_290 = ModuleKeyCode._("库存查询", "290");
  static const $_291 = ModuleKeyCode._("出入库明细", "291");
  static const $_292 = ModuleKeyCode._("出入库汇总", "292");
  static const $_350 = ModuleKeyCode._("菜单", "350");
  static const $_351 = ModuleKeyCode._("外设", "351");
  static const $_352 = ModuleKeyCode._("抹零", "352");
  static const $_353 = ModuleKeyCode._("热键", "353");
  static const $_354 = ModuleKeyCode._("打印机管理", "354");
  static const $_355 = ModuleKeyCode._("收银模板", "355");
  static const $_356 = ModuleKeyCode._("商品档案", "356");
  static const $_357 = ModuleKeyCode._("清除数据", "357");
  static const $_358 = ModuleKeyCode._("修改密码", "358");
  static const $_359 = ModuleKeyCode._("移动支付", "359");
  static const $_360 = ModuleKeyCode._("条码秤", "360");
  static const $_361 = ModuleKeyCode._("新品申请", "361");
  static const $_362 = ModuleKeyCode._("条码价签", "362");
  static const $_363 = ModuleKeyCode._("商品调价", "363");
  static const $_364 = ModuleKeyCode._("包装签模板", "364");
  static const $_365 = ModuleKeyCode._("收银参数", "365");
  static const $_400 = ModuleKeyCode._("门店外卖", "400");
  static const $_401 = ModuleKeyCode._("外卖订单", "401");
  static const $_402 = ModuleKeyCode._("外卖管理", "402");
  static const $_403 = ModuleKeyCode._("外卖商品", "403");
  static const $_450 = ModuleKeyCode._("商场接口", "450");
  static const $_451 = ModuleKeyCode._("关于我们", "451");
  static const $_500 = ModuleKeyCode._("新建寄存", "500");
  static const $_501 = ModuleKeyCode._("寄存取货", "501");
  static const $_502 = ModuleKeyCode._("跨店取货", "502");
  static const $_510 = ModuleKeyCode._("储值余额变动查询", "510");
  static const $_511 = ModuleKeyCode._("个人储值详情汇总", "511");
  static const $_512 = ModuleKeyCode._("门店储值详情汇总", "512");
  static const $_513 = ModuleKeyCode._("储值卡充值查询", "513");
  static const $_514 = ModuleKeyCode._("储值卡消费查询", "514");
  static const $_515 = ModuleKeyCode._("计次充值明细", "515");
  static const $_516 = ModuleKeyCode._("计次充值汇总", "516");
  static const $_517 = ModuleKeyCode._("计次消费明细", "517");
  static const $_518 = ModuleKeyCode._("计次消费汇总", "518");
  static const $_519 = ModuleKeyCode._("积分调整查询", "519");
  static const $_520 = ModuleKeyCode._("会员个人积分详情", "520");
  static const $_521 = ModuleKeyCode._("商品积分详情", "521");
  static const $_522 = ModuleKeyCode._("促销档期", "522");
  static const $_523 = ModuleKeyCode._("促销方案", "523");
  static const $_524 = ModuleKeyCode._("促销查询", "524");
  static const $_525 = ModuleKeyCode._("界面设置", "525");
  static const $_526 = ModuleKeyCode._("登录", "526");
  static const $_527 = ModuleKeyCode._("退出登录", "527");
  static const $_528 = ModuleKeyCode._("操作日志", "528");
  static const $_529 = ModuleKeyCode._("热卖商品", "529");
  static const $_530 = ModuleKeyCode._("数据下载", "530");
  static const $_531 = ModuleKeyCode._("分拣参数", "531");
  static const $_550 = ModuleKeyCode._("技师管理", "550");
  static const $_551 = ModuleKeyCode._("班次管理", "551");
  static const $_552 = ModuleKeyCode._("技师排班", "552");
  static const $_553 = ModuleKeyCode._("预约记录", "553");
  static const $_554 = ModuleKeyCode._("补打", "554");
  static const $_555 = ModuleKeyCode._("打印开关", "555");
  static const $_556 = ModuleKeyCode._("挂账单模板", "556");
  static const $_557 = ModuleKeyCode._("备用金", "557");
  static const $_558 = ModuleKeyCode._("快速调价", "558");
  static const $_559 = ModuleKeyCode._("调价模式", "559");
  static const $_560 = ModuleKeyCode._("退出调价模式", "560");
  static const $_561 = ModuleKeyCode._("支付方式", "561");
  static const $_562 = ModuleKeyCode._("备注", "562");
  static const $_563 = ModuleKeyCode._("预包装打印开关", "563");
  static const $_564 = ModuleKeyCode._("礼品卡", "564");
  static const $_565 = ModuleKeyCode._("新建预约", "565");
  static const $_566 = ModuleKeyCode._("取消预约", "566");
  static const $_567 = ModuleKeyCode._("预约服务", "567");
  static const $_568 = ModuleKeyCode._("预约叫号", "568");
  static const $_569 = ModuleKeyCode._("预约过号", "569");
  static const $_600 = ModuleKeyCode._("生成快速盘点单", "600");
  static const $_601 = ModuleKeyCode._("快速盘点单暂存", "601");
  static const $_602 = ModuleKeyCode._("快速盘点单编辑", "602");
  static const $_603 = ModuleKeyCode._("快速盘点单删除明细", "603");
  static const $_604 = ModuleKeyCode._("快速盘点单打印", "604");
  static const $_605 = ModuleKeyCode._("加载快速盘点商品", "605");
  static const $_606 = ModuleKeyCode._("快速盘点", "606");
  static const $_607 = ModuleKeyCode._("退出快速盘点", "607");

  static const $_701 = ModuleKeyCode._("开台", "701", permissionCode: "12001");
  static const $_702 = ModuleKeyCode._("消台", "702", permissionCode: "12002");
  static const $_703 = ModuleKeyCode._("并台", "703", permissionCode: "12003");
  static const $_704 = ModuleKeyCode._("拆台", "704", permissionCode: "12004");
  static const $_705 = ModuleKeyCode._("转台", "705", permissionCode: "12005");
  static const $_706 = ModuleKeyCode._("下单", "706", permissionCode: "12006");
  static const $_707 = ModuleKeyCode._("预结单", "707", permissionCode: "12007");

  factory ModuleKeyCode.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return ModuleKeyCode.$_1;
        }
      case "2":
        {
          return ModuleKeyCode.$_2;
        }
      case "3":
        {
          return ModuleKeyCode.$_3;
        }
      case "4":
        {
          return ModuleKeyCode.$_4;
        }
      case "5":
        {
          return ModuleKeyCode.$_5;
        }
      case "6":
        {
          return ModuleKeyCode.$_6;
        }
      case "7":
        {
          return ModuleKeyCode.$_7;
        }
      case "8":
        {
          return ModuleKeyCode.$_8;
        }
      case "9":
        {
          return ModuleKeyCode.$_9;
        }
      case "10":
        {
          return ModuleKeyCode.$_10;
        }
      case "11":
        {
          return ModuleKeyCode.$_11;
        }
      case "101":
        {
          return ModuleKeyCode.$_101;
        }
      case "104":
        {
          return ModuleKeyCode.$_104;
        }
      case "105":
        {
          return ModuleKeyCode.$_105;
        }
      case "106":
        {
          return ModuleKeyCode.$_106;
        }
      case "107":
        {
          return ModuleKeyCode.$_107;
        }
      case "108":
        {
          return ModuleKeyCode.$_108;
        }
      case "109":
        {
          return ModuleKeyCode.$_109;
        }
      case "110":
        {
          return ModuleKeyCode.$_110;
        }
      case "111":
        {
          return ModuleKeyCode.$_111;
        }
      case "112":
        {
          return ModuleKeyCode.$_112;
        }
      case "113":
        {
          return ModuleKeyCode.$_113;
        }
      case "114":
        {
          return ModuleKeyCode.$_114;
        }
      case "115":
        {
          return ModuleKeyCode.$_115;
        }
      case "116":
        {
          return ModuleKeyCode.$_116;
        }
      case "117":
        {
          return ModuleKeyCode.$_117;
        }
      case "118":
        {
          return ModuleKeyCode.$_118;
        }
      case "119":
        {
          return ModuleKeyCode.$_119;
        }
      case "120":
        {
          return ModuleKeyCode.$_120;
        }
      case "121":
        {
          return ModuleKeyCode.$_121;
        }
      case "122":
        {
          return ModuleKeyCode.$_122;
        }
      case "123":
        {
          return ModuleKeyCode.$_123;
        }
      case "124":
        {
          return ModuleKeyCode.$_124;
        }
      case "125":
        {
          return ModuleKeyCode.$_125;
        }
      case "126":
        {
          return ModuleKeyCode.$_126;
        }
      case "127":
        {
          return ModuleKeyCode.$_127;
        }
      case "128":
        {
          return ModuleKeyCode.$_128;
        }
      case "129":
        {
          return ModuleKeyCode.$_129;
        }
      case "130":
        {
          return ModuleKeyCode.$_130;
        }
      case "131":
        {
          return ModuleKeyCode.$_131;
        }
      case "132":
        {
          return ModuleKeyCode.$_132;
        }
      case "133":
        {
          return ModuleKeyCode.$_133;
        }
      case "134":
        {
          return ModuleKeyCode.$_134;
        }
      case "135":
        {
          return ModuleKeyCode.$_135;
        }
      case "136":
        {
          return ModuleKeyCode.$_136;
        }
      case "137":
        {
          return ModuleKeyCode.$_137;
        }
      case "138":
        {
          return ModuleKeyCode.$_138;
        }
      case "139":
        {
          return ModuleKeyCode.$_139;
        }
      case "140":
        {
          return ModuleKeyCode.$_140;
        }
      case "141":
        {
          return ModuleKeyCode.$_141;
        }
      case "142":
        {
          return ModuleKeyCode.$_142;
        }
      case "143":
        {
          return ModuleKeyCode.$_143;
        }
      case "144":
        {
          return ModuleKeyCode.$_144;
        }
      case "145":
        {
          return ModuleKeyCode.$_145;
        }
      case "146":
        {
          return ModuleKeyCode.$_146;
        }
      case "147":
        {
          return ModuleKeyCode.$_147;
        }
      case "148":
        {
          return ModuleKeyCode.$_148;
        }
      case "149":
        {
          return ModuleKeyCode.$_149;
        }
      case "150":
        {
          return ModuleKeyCode.$_150;
        }
      case "151":
        {
          return ModuleKeyCode.$_151;
        }
      case "152":
        {
          return ModuleKeyCode.$_152;
        }
      case "153":
        {
          return ModuleKeyCode.$_153;
        }
      case "154":
        {
          return ModuleKeyCode.$_154;
        }
      case "155":
        {
          return ModuleKeyCode.$_155;
        }
      case "156":
        {
          return ModuleKeyCode.$_156;
        }
      case "157":
        {
          return ModuleKeyCode.$_157;
        }
      case "158":
        {
          return ModuleKeyCode.$_158;
        }
      case "159":
        {
          return ModuleKeyCode.$_159;
        }
      case "160":
        {
          return ModuleKeyCode.$_160;
        }
      case "161":
        {
          return ModuleKeyCode.$_161;
        }
      case "162":
        {
          return ModuleKeyCode.$_162;
        }
      case "163":
        {
          return ModuleKeyCode.$_163;
        }
      case "164":
        {
          return ModuleKeyCode.$_164;
        }
      case "165":
        {
          return ModuleKeyCode.$_165;
        }
      case "166":
        {
          return ModuleKeyCode.$_166;
        }
      case "167":
        {
          return ModuleKeyCode.$_167;
        }
      case "200":
        {
          return ModuleKeyCode.$_200;
        }
      case "201":
        {
          return ModuleKeyCode.$_201;
        }
      case "202":
        {
          return ModuleKeyCode.$_202;
        }
      case "203":
        {
          return ModuleKeyCode.$_203;
        }
      case "204":
        {
          return ModuleKeyCode.$_204;
        }
      case "205":
        {
          return ModuleKeyCode.$_205;
        }
      case "206":
        {
          return ModuleKeyCode.$_206;
        }
      case "207":
        {
          return ModuleKeyCode.$_207;
        }
      case "208":
        {
          return ModuleKeyCode.$_208;
        }
      case "209":
        {
          return ModuleKeyCode.$_209;
        }
      case "210":
        {
          return ModuleKeyCode.$_210;
        }
      case "211":
        {
          return ModuleKeyCode.$_211;
        }
      case "212":
        {
          return ModuleKeyCode.$_212;
        }
      case "213":
        {
          return ModuleKeyCode.$_213;
        }
      case "214":
        {
          return ModuleKeyCode.$_214;
        }
      case "215":
        {
          return ModuleKeyCode.$_215;
        }
      case "230":
        {
          return ModuleKeyCode.$_230;
        }
      case "231":
        {
          return ModuleKeyCode.$_231;
        }
      case "232":
        {
          return ModuleKeyCode.$_232;
        }
      case "233":
        {
          return ModuleKeyCode.$_233;
        }
      case "234":
        {
          return ModuleKeyCode.$_234;
        }
      case "235":
        {
          return ModuleKeyCode.$_235;
        }
      case "236":
        {
          return ModuleKeyCode.$_236;
        }
      case "237":
        {
          return ModuleKeyCode.$_237;
        }
      case "238":
        {
          return ModuleKeyCode.$_238;
        }
      case "239":
        {
          return ModuleKeyCode.$_239;
        }
      case "240":
        {
          return ModuleKeyCode.$_240;
        }
      case "241":
        {
          return ModuleKeyCode.$_241;
        }
      case "242":
        {
          return ModuleKeyCode.$_242;
        }
      case "243":
        {
          return ModuleKeyCode.$_243;
        }
      case "244":
        {
          return ModuleKeyCode.$_244;
        }
      case "245":
        {
          return ModuleKeyCode.$_245;
        }
      case "246":
        {
          return ModuleKeyCode.$_246;
        }
      case "260":
        {
          return ModuleKeyCode.$_260;
        }
      case "261":
        {
          return ModuleKeyCode.$_261;
        }
      case "262":
        {
          return ModuleKeyCode.$_262;
        }
      case "263":
        {
          return ModuleKeyCode.$_263;
        }
      case "264":
        {
          return ModuleKeyCode.$_264;
        }
      case "265":
        {
          return ModuleKeyCode.$_265;
        }
      case "290":
        {
          return ModuleKeyCode.$_290;
        }
      case "291":
        {
          return ModuleKeyCode.$_291;
        }
      case "292":
        {
          return ModuleKeyCode.$_292;
        }
      case "350":
        {
          return ModuleKeyCode.$_350;
        }
      case "351":
        {
          return ModuleKeyCode.$_351;
        }
      case "352":
        {
          return ModuleKeyCode.$_352;
        }
      case "353":
        {
          return ModuleKeyCode.$_353;
        }
      case "354":
        {
          return ModuleKeyCode.$_354;
        }
      case "355":
        {
          return ModuleKeyCode.$_355;
        }
      case "356":
        {
          return ModuleKeyCode.$_356;
        }
      case "357":
        {
          return ModuleKeyCode.$_357;
        }
      case "358":
        {
          return ModuleKeyCode.$_358;
        }
      case "359":
        {
          return ModuleKeyCode.$_359;
        }
      case "360":
        {
          return ModuleKeyCode.$_360;
        }
      case "361":
        {
          return ModuleKeyCode.$_361;
        }
      case "362":
        {
          return ModuleKeyCode.$_362;
        }
      case "363":
        {
          return ModuleKeyCode.$_363;
        }
      case "364":
        {
          return ModuleKeyCode.$_364;
        }
      case "365":
        {
          return ModuleKeyCode.$_365;
        }
      case "400":
        {
          return ModuleKeyCode.$_400;
        }
      case "401":
        {
          return ModuleKeyCode.$_401;
        }
      case "402":
        {
          return ModuleKeyCode.$_402;
        }
      case "403":
        {
          return ModuleKeyCode.$_403;
        }
      case "450":
        {
          return ModuleKeyCode.$_450;
        }
      case "451":
        {
          return ModuleKeyCode.$_451;
        }
      case "500":
        {
          return ModuleKeyCode.$_500;
        }
      case "501":
        {
          return ModuleKeyCode.$_501;
        }
      case "502":
        {
          return ModuleKeyCode.$_502;
        }
      case "510":
        {
          return ModuleKeyCode.$_510;
        }
      case "511":
        {
          return ModuleKeyCode.$_511;
        }
      case "512":
        {
          return ModuleKeyCode.$_512;
        }
      case "513":
        {
          return ModuleKeyCode.$_513;
        }
      case "514":
        {
          return ModuleKeyCode.$_514;
        }
      case "515":
        {
          return ModuleKeyCode.$_515;
        }
      case "516":
        {
          return ModuleKeyCode.$_516;
        }
      case "517":
        {
          return ModuleKeyCode.$_517;
        }
      case "518":
        {
          return ModuleKeyCode.$_518;
        }
      case "519":
        {
          return ModuleKeyCode.$_519;
        }
      case "520":
        {
          return ModuleKeyCode.$_520;
        }
      case "521":
        {
          return ModuleKeyCode.$_521;
        }
      case "522":
        {
          return ModuleKeyCode.$_522;
        }
      case "523":
        {
          return ModuleKeyCode.$_523;
        }
      case "524":
        {
          return ModuleKeyCode.$_524;
        }
      case "525":
        {
          return ModuleKeyCode.$_525;
        }
      case "526":
        {
          return ModuleKeyCode.$_526;
        }
      case "527":
        {
          return ModuleKeyCode.$_527;
        }
      case "528":
        {
          return ModuleKeyCode.$_528;
        }
      case "529":
        {
          return ModuleKeyCode.$_529;
        }
      case "530":
        {
          return ModuleKeyCode.$_530;
        }
      case "531":
        {
          return ModuleKeyCode.$_531;
        }
      case "550":
        {
          return ModuleKeyCode.$_550;
        }
      case "551":
        {
          return ModuleKeyCode.$_551;
        }
      case "552":
        {
          return ModuleKeyCode.$_552;
        }
      case "553":
        {
          return ModuleKeyCode.$_553;
        }
      case "554":
        {
          return ModuleKeyCode.$_554;
        }
      case "555":
        {
          return ModuleKeyCode.$_555;
        }
      case "556":
        {
          return ModuleKeyCode.$_556;
        }
      case "557":
        {
          return ModuleKeyCode.$_557;
        }
      case "558":
        {
          return ModuleKeyCode.$_558;
        }
      case "559":
        {
          return ModuleKeyCode.$_559;
        }
      case "560":
        {
          return ModuleKeyCode.$_560;
        }
      case "561":
        {
          return ModuleKeyCode.$_561;
        }
      case "562":
        {
          return ModuleKeyCode.$_562;
        }
      case "563":
        {
          return ModuleKeyCode.$_563;
        }
      case "564":
        {
          return ModuleKeyCode.$_564;
        }
      case "565":
        {
          return ModuleKeyCode.$_565;
        }
      case "566":
        {
          return ModuleKeyCode.$_566;
        }
      case "567":
        {
          return ModuleKeyCode.$_567;
        }
      case "568":
        {
          return ModuleKeyCode.$_568;
        }
      case "569":
        {
          return ModuleKeyCode.$_569;
        }
      case "600":
        {
          return ModuleKeyCode.$_600;
        }
      case "601":
        {
          return ModuleKeyCode.$_601;
        }
      case "602":
        {
          return ModuleKeyCode.$_602;
        }
      case "603":
        {
          return ModuleKeyCode.$_603;
        }
      case "604":
        {
          return ModuleKeyCode.$_604;
        }
      case "605":
        {
          return ModuleKeyCode.$_605;
        }
      case "606":
        {
          return ModuleKeyCode.$_606;
        }
      case "607":
        {
          return ModuleKeyCode.$_607;
        }
      default:
        {
          return ModuleKeyCode.$_0;
        }
    }
  }

  factory ModuleKeyCode.fromName(String name) {
    switch (name) {
      case "收银模块":
        {
          return ModuleKeyCode.$_1;
        }
      case "外卖模块":
        {
          return ModuleKeyCode.$_2;
        }
      case "促销模块":
        {
          return ModuleKeyCode.$_3;
        }
      case "会员模块":
        {
          return ModuleKeyCode.$_4;
        }
      case "预约模块":
        {
          return ModuleKeyCode.$_5;
        }
      case "库存模块":
        {
          return ModuleKeyCode.$_6;
        }
      case "报表模块":
        {
          return ModuleKeyCode.$_7;
        }
      case "设置模块":
        {
          return ModuleKeyCode.$_8;
        }
      case "关于模块":
        {
          return ModuleKeyCode.$_9;
        }
      case "帮助模块":
        {
          return ModuleKeyCode.$_10;
        }
      case "采购模块":
        {
          return ModuleKeyCode.$_11;
        }
      case "结账":
        {
          return ModuleKeyCode.$_101;
        }
      case "数量":
        {
          return ModuleKeyCode.$_104;
        }
      case "数量加":
        {
          return ModuleKeyCode.$_105;
        }
      case "数量减":
        {
          return ModuleKeyCode.$_106;
        }
      case "改价":
        {
          return ModuleKeyCode.$_107;
        }
      case "折扣":
        {
          return ModuleKeyCode.$_108;
        }
      case "删除单品":
        {
          return ModuleKeyCode.$_109;
        }
      case "赠送":
        {
          return ModuleKeyCode.$_110;
        }
      case "做法":
        {
          return ModuleKeyCode.$_111;
        }
      case "规格":
        {
          return ModuleKeyCode.$_112;
        }
      case "换菜":
        {
          return ModuleKeyCode.$_113;
        }
      case "取消全单":
        {
          return ModuleKeyCode.$_114;
        }
      case "会员":
        {
          return ModuleKeyCode.$_115;
        }
      case "导购":
        {
          return ModuleKeyCode.$_116;
        }
      case "整单议价":
        {
          return ModuleKeyCode.$_117;
        }
      case "整单折扣":
        {
          return ModuleKeyCode.$_118;
        }
      case "挂单":
        {
          return ModuleKeyCode.$_119;
        }
      case "取单":
        {
          return ModuleKeyCode.$_120;
        }
      case "交班":
        {
          return ModuleKeyCode.$_121;
        }
      case "退货":
        {
          return ModuleKeyCode.$_122;
        }
      case "锁屏":
        {
          return ModuleKeyCode.$_123;
        }
      case "清零":
        {
          return ModuleKeyCode.$_124;
        }
      case "去皮":
        {
          return ModuleKeyCode.$_125;
        }
      case "凑整":
        {
          return ModuleKeyCode.$_126;
        }
      case "寄存":
        {
          return ModuleKeyCode.$_127;
        }
      case "开钱箱":
        {
          return ModuleKeyCode.$_128;
        }
      case "连续称重":
        {
          return ModuleKeyCode.$_129;
        }
      case "会员卡开户":
        {
          return ModuleKeyCode.$_130;
        }
      case "会员卡充值":
        {
          return ModuleKeyCode.$_131;
        }
      case "会员卡退卡":
        {
          return ModuleKeyCode.$_132;
        }
      case "会员卡冻结":
        {
          return ModuleKeyCode.$_133;
        }
      case "会员卡解冻":
        {
          return ModuleKeyCode.$_134;
        }
      case "会员卡充值消费记录":
        {
          return ModuleKeyCode.$_135;
        }
      case "会员卡挂失":
        {
          return ModuleKeyCode.$_136;
        }
      case "会员卡解挂":
        {
          return ModuleKeyCode.$_137;
        }
      case "会员信息修改":
        {
          return ModuleKeyCode.$_138;
        }
      case "计次充值":
        {
          return ModuleKeyCode.$_139;
        }
      case "计次消费":
        {
          return ModuleKeyCode.$_140;
        }
      case "会员管理":
        {
          return ModuleKeyCode.$_141;
        }
      case "兑换礼品":
        {
          return ModuleKeyCode.$_142;
        }
      case "兑换储值":
        {
          return ModuleKeyCode.$_143;
        }
      case "会员报表":
        {
          return ModuleKeyCode.$_144;
        }
      case "积分变动查询":
        {
          return ModuleKeyCode.$_145;
        }
      case "积分兑换查询":
        {
          return ModuleKeyCode.$_146;
        }
      case "积分调整":
        {
          return ModuleKeyCode.$_147;
        }
      case "会员卡换卡":
        {
          return ModuleKeyCode.$_148;
        }
      case "会员修改密码":
        {
          return ModuleKeyCode.$_149;
        }
      case "销售流水":
        {
          return ModuleKeyCode.$_150;
        }
      case "营业日报":
        {
          return ModuleKeyCode.$_151;
        }
      case "收款流水":
        {
          return ModuleKeyCode.$_152;
        }
      case "商品销售流水":
        {
          return ModuleKeyCode.$_153;
        }
      case "商品销售汇总":
        {
          return ModuleKeyCode.$_154;
        }
      case "交班记录":
        {
          return ModuleKeyCode.$_155;
        }
      case "寄存报表":
        {
          return ModuleKeyCode.$_156;
        }
      case "错充处理":
        {
          return ModuleKeyCode.$_157;
        }
      case "桌号":
        {
          return ModuleKeyCode.$_158;
        }
      case "连续开关":
        {
          return ModuleKeyCode.$_159;
        }
      case "重新写卡":
        {
          return ModuleKeyCode.$_160;
        }
      case "会员折扣券":
        {
          return ModuleKeyCode.$_161;
        }
      case "购买PLUS会员":
        {
          return ModuleKeyCode.$_162;
        }
      case "删除挂单":
        {
          return ModuleKeyCode.$_163;
        }
      case "业务菜单":
        {
          return ModuleKeyCode.$_164;
        }
      case "会员卡小额充值":
        {
          return ModuleKeyCode.$_165;
        }
      case "异常支付":
        {
          return ModuleKeyCode.$_166;
        }
      case "礼品卡销售":
        {
          return ModuleKeyCode.$_167;
        }
      case "要货单":
        {
          return ModuleKeyCode.$_200;
        }
      case "总部统配收货":
        {
          return ModuleKeyCode.$_201;
        }
      case "统配收货差异":
        {
          return ModuleKeyCode.$_202;
        }
      case "商品调回总部":
        {
          return ModuleKeyCode.$_203;
        }
      case "店间直调申请":
        {
          return ModuleKeyCode.$_204;
        }
      case "店间直调发货":
        {
          return ModuleKeyCode.$_205;
        }
      case "店间直调收货":
        {
          return ModuleKeyCode.$_206;
        }
      case "店间直调差异":
        {
          return ModuleKeyCode.$_207;
        }
      case "店间直调退货":
        {
          return ModuleKeyCode.$_208;
        }
      case "其他出库":
        {
          return ModuleKeyCode.$_209;
        }
      case "其他入库":
        {
          return ModuleKeyCode.$_210;
        }
      case "要货汇总":
        {
          return ModuleKeyCode.$_211;
        }
      case "配送明细":
        {
          return ModuleKeyCode.$_212;
        }
      case "配送汇总":
        {
          return ModuleKeyCode.$_213;
        }
      case "商品调回申请":
        {
          return ModuleKeyCode.$_214;
        }
      case "店间退货申请":
        {
          return ModuleKeyCode.$_215;
        }
      case "采购订单":
        {
          return ModuleKeyCode.$_230;
        }
      case "采购入库":
        {
          return ModuleKeyCode.$_231;
        }
      case "采购退货":
        {
          return ModuleKeyCode.$_232;
        }
      case "促销进价单":
        {
          return ModuleKeyCode.$_233;
        }
      case "采购明细":
        {
          return ModuleKeyCode.$_234;
        }
      case "采购汇总":
        {
          return ModuleKeyCode.$_235;
        }
      case "联营账款单":
        {
          return ModuleKeyCode.$_236;
        }
      case "代销账款单":
        {
          return ModuleKeyCode.$_237;
        }
      case "扣率代销账款单":
        {
          return ModuleKeyCode.$_238;
        }
      case "供应商费用单":
        {
          return ModuleKeyCode.$_239;
        }
      case "供应商预付款单":
        {
          return ModuleKeyCode.$_240;
        }
      case "供应商结算单":
        {
          return ModuleKeyCode.$_241;
        }
      case "供应商往来账款":
        {
          return ModuleKeyCode.$_242;
        }
      case "联营销售查询":
        {
          return ModuleKeyCode.$_243;
        }
      case "代销销售查询":
        {
          return ModuleKeyCode.$_244;
        }
      case "扣率代销销售查询":
        {
          return ModuleKeyCode.$_245;
        }
      case "促销补差单":
        {
          return ModuleKeyCode.$_246;
        }
      case "盘点号申请":
        {
          return ModuleKeyCode.$_260;
        }
      case "商品盘点单":
        {
          return ModuleKeyCode.$_261;
        }
      case "盘点差异处理":
        {
          return ModuleKeyCode.$_262;
        }
      case "盘点明细":
        {
          return ModuleKeyCode.$_263;
        }
      case "漏盘商品":
        {
          return ModuleKeyCode.$_264;
        }
      case "盘点差异":
        {
          return ModuleKeyCode.$_265;
        }
      case "库存查询":
        {
          return ModuleKeyCode.$_290;
        }
      case "出入库明细":
        {
          return ModuleKeyCode.$_291;
        }
      case "出入库汇总":
        {
          return ModuleKeyCode.$_292;
        }
      case "菜单":
        {
          return ModuleKeyCode.$_350;
        }
      case "外设":
        {
          return ModuleKeyCode.$_351;
        }
      case "抹零":
        {
          return ModuleKeyCode.$_352;
        }
      case "热键":
        {
          return ModuleKeyCode.$_353;
        }
      case "打印机管理":
        {
          return ModuleKeyCode.$_354;
        }
      case "收银模板":
        {
          return ModuleKeyCode.$_355;
        }
      case "商品档案":
        {
          return ModuleKeyCode.$_356;
        }
      case "清除数据":
        {
          return ModuleKeyCode.$_357;
        }
      case "修改密码":
        {
          return ModuleKeyCode.$_358;
        }
      case "移动支付":
        {
          return ModuleKeyCode.$_359;
        }
      case "条码秤":
        {
          return ModuleKeyCode.$_360;
        }
      case "新品申请":
        {
          return ModuleKeyCode.$_361;
        }
      case "条码价签":
        {
          return ModuleKeyCode.$_362;
        }
      case "商品调价":
        {
          return ModuleKeyCode.$_363;
        }
      case "包装签模板":
        {
          return ModuleKeyCode.$_364;
        }
      case "收银参数":
        {
          return ModuleKeyCode.$_365;
        }
      case "门店外卖":
        {
          return ModuleKeyCode.$_400;
        }
      case "外卖订单":
        {
          return ModuleKeyCode.$_401;
        }
      case "外卖管理":
        {
          return ModuleKeyCode.$_402;
        }
      case "外卖商品":
        {
          return ModuleKeyCode.$_403;
        }
      case "商场接口":
        {
          return ModuleKeyCode.$_450;
        }
      case "关于我们":
        {
          return ModuleKeyCode.$_451;
        }
      case "新建寄存":
        {
          return ModuleKeyCode.$_500;
        }
      case "寄存取货":
        {
          return ModuleKeyCode.$_501;
        }
      case "跨店取货":
        {
          return ModuleKeyCode.$_502;
        }
      case "储值余额变动查询":
        {
          return ModuleKeyCode.$_510;
        }
      case "个人储值详情汇总":
        {
          return ModuleKeyCode.$_511;
        }
      case "门店储值详情汇总":
        {
          return ModuleKeyCode.$_512;
        }
      case "储值卡充值查询":
        {
          return ModuleKeyCode.$_513;
        }
      case "储值卡消费查询":
        {
          return ModuleKeyCode.$_514;
        }
      case "计次充值明细":
        {
          return ModuleKeyCode.$_515;
        }
      case "计次充值汇总":
        {
          return ModuleKeyCode.$_516;
        }
      case "计次消费明细":
        {
          return ModuleKeyCode.$_517;
        }
      case "计次消费汇总":
        {
          return ModuleKeyCode.$_518;
        }
      case "积分调整查询":
        {
          return ModuleKeyCode.$_519;
        }
      case "会员个人积分详情":
        {
          return ModuleKeyCode.$_520;
        }
      case "商品积分详情":
        {
          return ModuleKeyCode.$_521;
        }
      case "促销档期":
        {
          return ModuleKeyCode.$_522;
        }
      case "促销方案":
        {
          return ModuleKeyCode.$_523;
        }
      case "促销查询":
        {
          return ModuleKeyCode.$_524;
        }
      case "界面设置":
        {
          return ModuleKeyCode.$_525;
        }
      case "登录":
        {
          return ModuleKeyCode.$_526;
        }
      case "退出登录":
        {
          return ModuleKeyCode.$_527;
        }
      case "操作日志":
        {
          return ModuleKeyCode.$_528;
        }
      case "热卖商品":
        {
          return ModuleKeyCode.$_529;
        }
      case "数据下载":
        {
          return ModuleKeyCode.$_530;
        }
      case "分拣参数":
        {
          return ModuleKeyCode.$_531;
        }
      case "技师管理":
        {
          return ModuleKeyCode.$_550;
        }
      case "班次管理":
        {
          return ModuleKeyCode.$_551;
        }
      case "技师排班":
        {
          return ModuleKeyCode.$_552;
        }
      case "预约记录":
        {
          return ModuleKeyCode.$_553;
        }
      case "补打":
        {
          return ModuleKeyCode.$_554;
        }
      case "打印开关":
        {
          return ModuleKeyCode.$_555;
        }
      case "挂账单模板":
        {
          return ModuleKeyCode.$_556;
        }
      case "备用金":
        {
          return ModuleKeyCode.$_557;
        }
      case "快速调价":
        {
          return ModuleKeyCode.$_558;
        }
      case "调价模式":
        {
          return ModuleKeyCode.$_559;
        }
      case "退出调价模式":
        {
          return ModuleKeyCode.$_560;
        }
      case "支付方式":
        {
          return ModuleKeyCode.$_561;
        }
      case "备注":
        {
          return ModuleKeyCode.$_562;
        }
      case "预包装打印开关":
        {
          return ModuleKeyCode.$_563;
        }
      case "礼品卡":
        {
          return ModuleKeyCode.$_564;
        }
      case "新建预约":
        {
          return ModuleKeyCode.$_565;
        }
      case "取消预约":
        {
          return ModuleKeyCode.$_566;
        }
      case "预约服务":
        {
          return ModuleKeyCode.$_567;
        }
      case "预约叫号":
        {
          return ModuleKeyCode.$_568;
        }
      case "预约过号":
        {
          return ModuleKeyCode.$_569;
        }
      case "生成快速盘点单":
        {
          return ModuleKeyCode.$_600;
        }
      case "快速盘点单暂存":
        {
          return ModuleKeyCode.$_601;
        }
      case "快速盘点单编辑":
        {
          return ModuleKeyCode.$_602;
        }
      case "快速盘点单删除明细":
        {
          return ModuleKeyCode.$_603;
        }
      case "快速盘点单打印":
        {
          return ModuleKeyCode.$_604;
        }
      case "加载快速盘点商品":
        {
          return ModuleKeyCode.$_605;
        }
      case "快速盘点":
        {
          return ModuleKeyCode.$_606;
        }
      case "退出快速盘点":
        {
          return ModuleKeyCode.$_607;
        }
      default:
        {
          return ModuleKeyCode.$_0;
        }
    }
  }

  @override
  String toString() {
    return "{ 'name':'${this.name}','value':'${this.value}'}";
  }
}
