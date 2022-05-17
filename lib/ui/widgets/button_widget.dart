import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.text,
    required this.onPressed}) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.pinkAccent)),
          onPressed: onPressed,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          )),
    );
  }
}
