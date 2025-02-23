
import 'package:flutter/material.dart';

class icon_widget extends StatelessWidget {
  final double radius;
  const icon_widget({super.key,required this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(radius), // Image radius
          child: Image.asset('icon/icon.jpg', fit: BoxFit.cover),
        ));
  }
}
