import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSize {
  final AppBar appBar;
  final Widget bottomWidget;
  final double height;
  final Color color;

  const MyCustomAppBar(
      {Key? key,
      required this.appBar,
      required this.bottomWidget,
      required this.height,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            height: height / 1.2,
            child: appBar,
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: bottomWidget,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget get child => this;

  @override
  Size get preferredSize => Size.fromHeight(height);
}
