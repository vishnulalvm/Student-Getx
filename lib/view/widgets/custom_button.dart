 import 'package:flutter/material.dart';
import 'package:myapp/utils/text/modified_text.dart';

Widget buttons({
  required double height,
  required double width,
    required VoidCallback onTap,
    required String buttonName,
    Color? color,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap, // Call the provided function when tapped
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: ModifiedText(
            text: buttonName,
            size: 12,
            color: textColor,
          ),
        ),
      ),
    );
  }