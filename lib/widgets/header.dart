import 'package:flutter/material.dart';

class HeaderLabel extends StatelessWidget {
  final String? headerText;
  
  HeaderLabel({
    Key? key, this.headerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText!,
      style: TextStyle( fontSize: 28.0),
    );
  }
}