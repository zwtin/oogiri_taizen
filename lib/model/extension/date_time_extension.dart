import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toJPString() {
    initializeDateFormatting('ja_JP');
    final formatter = DateFormat('yyyy/MM/dd HH:mm', 'ja_JP');
    final formatted = formatter.format(this); // DateからString
    return formatted;
  }
}
