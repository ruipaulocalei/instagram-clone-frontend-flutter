import 'package:flutter/material.dart';

showDialogWidget(BuildContext context, String title, String content) {
  showDialog<void>(
    context: context,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(dialogContext)
                  .pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}