import 'package:flutter/material.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/models/content.dart';

Widget buildList(Content contentList) {
  if (contentList != null) {
    return Builder(builder: (context) {
      return ListTile(
          onTap: () => {},
          leading: const SizedBox(),
          title: Text(contentList.title));
    });
  }
  return const ExpansionTile(
    leading: Icon(Tothem.trash),
    title: Text(
      'prueba',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    children: [Text('pruebasita')],
  );
}
