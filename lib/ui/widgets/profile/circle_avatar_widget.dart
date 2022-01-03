import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({Key? key, required this.height,
    required this.width}) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Colors.grey),
    );
  }
}
