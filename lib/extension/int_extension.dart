extension IntExtension on int {
  String toStringOverTenThousand() {
    if (this >= 1000000) {
      final dividedNumber = (this / 100000).floor() / 10.0;
      return '${dividedNumber}M';
    } else if (this >= 10000) {
      final dividedNumber = (this / 100).floor() / 10.0;
      return '${dividedNumber}k';
    } else {
      return toString();
    }
  }
}
