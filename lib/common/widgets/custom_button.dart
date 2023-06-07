import 'package:flutter/material.dart';
import 'package:user_groceryapp/common/utils/colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(15)),

        height: 40,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: whiteColor,
            ),
          ),
        ),

        // style: ElevatedButton.styleFrom(
        //   minimumSize: const Size(double.infinity, 50),
        // ),
      ),
    );
  }
}
