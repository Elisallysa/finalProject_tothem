import 'package:flutter/material.dart';

import 'package:tothem/src/common/assets/tothem_icons.dart';

SliverAppBar getScrollableAppBar() {
  return const SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: Icon(Tothem.checkmarkCicle),
      expandedHeight: 120,
      floating: true,
      snap: true);
}

Container getHomeHeader() {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
    ),
    width: double.infinity,
    height: double.infinity,
    child: Align(
      alignment: const AlignmentDirectional(0, -1.35),
      child: Container(
        //margin: EdgeInsets.all(20),
        width: 400,
        height: 125,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
                'https://patientcaremedical.com/wp-content/uploads/2018/04/male-catheters.jpg'),
          ),
        ),
      ),
    ),
  );
}

Align getContentArea(BuildContext context) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
        color: Colors.black,
        height: 300,
        width: MediaQuery.of(context).size.width * 0.8),
  );
}
