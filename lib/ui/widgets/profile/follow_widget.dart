import 'package:flutter/material.dart';

class FollowWidget extends StatelessWidget {
  const FollowWidget({Key? key, required this.number,
    required this.text}) : super(key: key);

  final int number;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        Text(text, overflow: TextOverflow.ellipsis,),
      ],
    );
  }
}
