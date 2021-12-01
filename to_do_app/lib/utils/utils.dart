import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static final _dateFormat = DateFormat.yMMMMd('en_US');

  static String formatDate(DateTime date) {
    if (date == null) return '';

    return _dateFormat.format(date);
  }

  static DateTime toDateTime(Timestamp value) {
    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}