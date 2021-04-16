class PostWay {
  final String name;
  final String value;
  const PostWay._(this.name, this.value);

  static const None = PostWay._("None", "-1");
  //自提
  static const Picked = PostWay._("自提", "0");
  //外送
  static const Outward = PostWay._("外送", "1");
  //堂食
  static const ForHere = PostWay._("堂食", "2");
//外带
  static const ToGo = PostWay._("外带", "3");
//外卖
  static const Takeout = PostWay._("外卖", "4");
//快递
  static const Express = PostWay._("快递", "5");

  factory PostWay.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PostWay.Picked;
        }
      case "1":
        {
          return PostWay.Outward;
        }
      case "2":
        {
          return PostWay.ForHere;
        }
      case "3":
        {
          return PostWay.ToGo;
        }
      case "4":
        {
          return PostWay.Takeout;
        }
      case "5":
        {
          return PostWay.Express;
        }
      default:
        {
          return PostWay.None;
        }
    }
  }

  factory PostWay.fromName(String name) {
    switch (name) {
      case "自提":
        {
          return PostWay.Picked;
        }
      case "外送":
        {
          return PostWay.Outward;
        }
      case "堂食":
        {
          return PostWay.ForHere;
        }
      case "外带":
        {
          return PostWay.ToGo;
        }
      case "外卖":
        {
          return PostWay.Takeout;
        }
      case "快递":
        {
          return PostWay.Express;
        }
      default:
        {
          return PostWay.None;
        }
    }
  }
}
