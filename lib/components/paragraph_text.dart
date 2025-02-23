import 'package:flutter/material.dart';
class ParagraphText extends StatelessWidget {
  final String text;
  const ParagraphText({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: Theme.of(context).textTheme.bodyLarge,);
  }
}
