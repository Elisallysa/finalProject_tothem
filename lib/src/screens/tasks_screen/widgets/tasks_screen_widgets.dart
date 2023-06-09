import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

RichText buildTaskDate(
    BuildContext context, String leadingText, DateTime date) {
  return RichText(
    text: TextSpan(
      style: DefaultTextStyle.of(context).style,
      children: <TextSpan>[
        TextSpan(
            text: leadingText,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: getFormattedDate(date)),
      ],
    ),
  );
}

String getFormattedDate(DateTime date) {
  initializeDateFormatting('es_ES', null);

  String formattedDate = DateFormat.yMMMMd('es_ES').format(date);
  String time = DateFormat.Hm().format(date);

  return '$formattedDate $time';
}
