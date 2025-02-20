
import 'package:flutter/material.dart';

Widget icon_widget(double radius) {
  return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(radius), // Image radius
        child: Image.asset('icon/icon.jpg', fit: BoxFit.cover),
      ));
}