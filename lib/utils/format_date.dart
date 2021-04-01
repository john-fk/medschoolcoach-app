import 'package:intl/intl.dart';

String formatDate(DateTime date, String format) {
  return DateFormat(format).format(date);
}
