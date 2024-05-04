import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtil{
  static String getFormattedTime(
  {required BuildContext context,required String time})
  {
    final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
  static String getFormattedDate({
    required BuildContext context,
    required String time,
  }) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(time) ?? 0);
      final formatter = DateFormat.yMMMMd(Localizations.localeOf(context).toString());
      return formatter.format(date);
    } catch (e) {
      print('Error formatting date: $e');
      return 'NA';
    }
  }



  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    try {
      final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.tryParse(time) ?? 0);
      final DateTime now = DateTime.now();

      if (now.day == sent.day &&
          now.month == sent.month &&
          now.year == sent.year) {
        return TimeOfDay.fromDateTime(sent).format(context);
      }

      return showYear
          ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
          : '${sent.day} ${_getMonth(sent)}';
    } catch (e) {
      print('Error getting last message time: $e');
      return 'NA';
    }
  }

  static String _getMonth(DateTime date)
  {
    switch(date.month)
        {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';

    }
    return 'NA';
  }

  static getLastActiveTime({required BuildContext context,required String lastActive})
{
  final int i= int.tryParse(lastActive) ??-1;
  if(i==-1) return 'Last seen not available';

  DateTime time=DateTime.fromMillisecondsSinceEpoch(i);
  DateTime now=DateTime.now();


  String formattedTime=TimeOfDay.fromDateTime(time).format(context);
  if(time.day==now.day && time.month==now.month && time.year==now.year)
    {
      return 'Last seen today at ${formattedTime}';
    }
  if((now.difference(time).inHours/24).round()==1)
    {
      return 'Last seen yesterday at ${formattedTime}';
    }

  String month=_getMonth(time);
  return 'Last seen on ${time.day} $month on $formattedTime';

}




}