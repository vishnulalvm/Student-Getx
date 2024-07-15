import 'package:flutter/material.dart';

class ModifiedText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight? fontWeight;
  final int? maxline;
  final TextOverflow? textOverflow;
  const ModifiedText(
      {super.key,
      required this.text,
      required this.size,
      required this.color,
      this.fontWeight,
      this.maxline,
      this.textOverflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxline,
      overflow: textOverflow,
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

class BoldText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const BoldText(
      {super.key, required this.text, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
