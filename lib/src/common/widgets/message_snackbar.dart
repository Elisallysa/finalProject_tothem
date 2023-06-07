import 'package:flutter/material.dart';

SnackBar alertSnackbar(String message, String buttonText, Function? action) {
  return SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: buttonText,
      onPressed: () {
        action;
      },
    ),
  );
}
