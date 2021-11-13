enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return '大喜利大全Dev';
      case Flavor.PRODUCTION:
        return '大喜利大全';
      default:
        return 'title';
    }
  }
}
