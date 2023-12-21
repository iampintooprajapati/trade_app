import 'package:flutter/material.dart';

class AppToast {
  static final AppToast instance = AppToast._internal();

  factory AppToast(BuildContext context) {
    return instance;
  }
  AppToast._internal();
  showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      duration: const Duration(milliseconds: 2000),
      dismissDirection: DismissDirection.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }

  showSuccess(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 12,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
      elevation: 10,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }
}
