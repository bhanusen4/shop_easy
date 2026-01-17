import 'package:flutter/material.dart';

Widget colorDot(Color color) {
  return Container(
    margin: const EdgeInsets.only(left: 2),
    height: 10,
    width: 10,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}