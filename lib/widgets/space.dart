import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double width;
  final double height;

  Space({this.height = 0, this.width = 0});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      height: this.height,
    );
  }
}
