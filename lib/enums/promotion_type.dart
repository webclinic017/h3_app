class PromotionType {
  final String name;
  final String value;
  const PromotionType._(this.name, this.value);

  static const None = PromotionType._("None", "-1");

  static const Gift = PromotionType._("赠送", "0");

  static const ProductDiscount = PromotionType._("单品折扣", "1");

  static const Coupon = PromotionType._("优惠券", "2");

  static const ProductBargain = PromotionType._("单品议价", "6");

  static const Reduction = PromotionType._("立减", "8");

  static const OrderReduction = PromotionType._("整单立减", "9");

  static const OrderFree = PromotionType._("免单", "10");

  static const MemberLevelDiscount = PromotionType._("会员等级优惠", "11");

  static const MakeDiscount = PromotionType._("做法折扣", "12");

  static const MalingCostSharing = PromotionType._("抹零分摊", "13");

  static const PlusPriceDiscount = PromotionType._("PLUS会员价优惠", "14");

  static const OrderDiscount = PromotionType._("整单折扣", "21");

  static const OrderBargain = PromotionType._("整单议价", "26");

  static const TakeawayFee = PromotionType._("外卖扣费", "30");

  static const ProductCostSharing = PromotionType._("捆绑商品分摊", "50");

  static const SuitCostSharing = PromotionType._("套餐商品分摊", "51");

  static const OnlinePromotion = PromotionType._("线上促销", "60");

  factory PromotionType.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PromotionType.Gift;
        }
      case "1":
        {
          return PromotionType.ProductDiscount;
        }
      case "2":
        {
          return PromotionType.Coupon;
        }
      case "6":
        {
          return PromotionType.ProductBargain;
        }
      case "8":
        {
          return PromotionType.Reduction;
        }
      case "9":
        {
          return PromotionType.OrderReduction;
        }
      case "10":
        {
          return PromotionType.OrderFree;
        }
      case "11":
        {
          return PromotionType.MemberLevelDiscount;
        }
      case "12":
        {
          return PromotionType.MakeDiscount;
        }
      case "13":
        {
          return PromotionType.MalingCostSharing;
        }
      case "14":
        {
          return PromotionType.PlusPriceDiscount;
        }
      case "21":
        {
          return PromotionType.OrderDiscount;
        }
      case "26":
        {
          return PromotionType.OrderBargain;
        }
      case "30":
        {
          return PromotionType.TakeawayFee;
        }
      case "50":
        {
          return PromotionType.ProductCostSharing;
        }
      case "51":
        {
          return PromotionType.SuitCostSharing;
        }
      case "60":
        {
          return PromotionType.OnlinePromotion;
        }
      default:
        {
          return PromotionType.None;
        }
    }
  }

  factory PromotionType.fromName(String name) {
    switch (name) {
      case "赠送":
        {
          return PromotionType.Gift;
        }
      case "单品折扣":
        {
          return PromotionType.ProductDiscount;
        }
      case "优惠券":
        {
          return PromotionType.Coupon;
        }
      case "单品议价":
        {
          return PromotionType.ProductBargain;
        }
      case "立减":
        {
          return PromotionType.Reduction;
        }
      case "整单立减":
        {
          return PromotionType.OrderReduction;
        }
      case "免单":
        {
          return PromotionType.OrderFree;
        }
      case "会员等级优惠":
        {
          return PromotionType.MemberLevelDiscount;
        }
      case "做法折扣":
        {
          return PromotionType.MakeDiscount;
        }
      case "抹零分摊":
        {
          return PromotionType.MalingCostSharing;
        }
      case "PLUS会员价优惠":
        {
          return PromotionType.PlusPriceDiscount;
        }
      case "整单折扣":
        {
          return PromotionType.OrderDiscount;
        }
      case "整单议价":
        {
          return PromotionType.OrderBargain;
        }
      case "外卖扣费":
        {
          return PromotionType.TakeawayFee;
        }
      case "捆绑商品分摊":
        {
          return PromotionType.ProductCostSharing;
        }
      case "套餐商品分摊":
        {
          return PromotionType.SuitCostSharing;
        }
      case "线上促销":
        {
          return PromotionType.OnlinePromotion;
        }
      default:
        {
          return PromotionType.None;
        }
    }
  }
}
