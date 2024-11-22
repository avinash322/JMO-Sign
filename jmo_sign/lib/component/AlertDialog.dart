import 'package:flutter/material.dart';

class CustomAlertDialogOneDialog extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback onPressed;
  final BuildContext context;

  CustomAlertDialogOneDialog({
    required this.title,
    this.message,
    required this.onPressed,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message ?? ""),
      actions: <Widget>[
        TextButton(child: Text("OK"), onPressed: onPressed),
      ],
    );
  }
}

void showCustomAlertDialogOneDialog({
  required String title,
  String? message,
  required VoidCallback onPressed,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomAlertDialogOneDialog(
        title: title,
        message: message,
        onPressed: onPressed,
        context: context,
      );
    },
  );
}
