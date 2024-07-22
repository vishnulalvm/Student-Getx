import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String message;
  final BuildContext context;
  final void Function()? onYes;

  const MyAlertDialog({
    super.key,
    required this.message,
    required this.context,
    this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            onYes;
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

// // Example usage:
// void showAlertDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return MyAlertDialog(message: 'Are you sure you want to proceed?');
//     },
//   ).then((value) {
//     if (value != null) {
//       print(value ? 'User pressed Yes' : 'User pressed No');
//     }
//   });
// }