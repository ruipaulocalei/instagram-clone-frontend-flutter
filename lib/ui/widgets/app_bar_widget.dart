import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }
}
