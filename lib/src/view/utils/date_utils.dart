import 'package:intl/intl.dart';

String getFormattedDateTime(String value) {
  if (value == null) return "";
  var formatterIn = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var formatterOut = DateFormat("yyyy-MM-dd HH:mm");
  var date = formatterIn.parse(value);
  return formatterOut.format(date);
}

String getFormattedDate(String value) {
  if (value == null) return "";
  var formatterIn = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var formatterOut = DateFormat("dd.MM.yyyy");
  var date = formatterIn.parse(value);
  return formatterOut.format(date);
}

String getHistoryDate(int millis) {
  var formatterOut = DateFormat("dd.MM.yyyy");
  var date = DateTime.fromMillisecondsSinceEpoch(millis);
  return formatterOut.format(date);
}
