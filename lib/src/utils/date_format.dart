import 'package:intl/intl.dart';

class DateExtension {
  getDate(DateTime date, {String format = "EEEE, MMM d, yyyy"}) {
    return DateFormat(format).format(date.toLocal());
  }
}
