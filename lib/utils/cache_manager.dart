import 'package:h3_app/entity/pos_make_info.dart';
import 'package:h3_app/order/product_ext.dart';

class CacheManager {
  //商品档案及规格信息缓存
  static List<ProductExt> productExtList;

  //商品做法信息缓存
  static Map<String, List<MakeInfo>> makeList = {};

  static clearAll() {
    productExtList = null;
    makeList.clear();
  }
}
