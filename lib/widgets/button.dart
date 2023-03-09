import 'package:flutter/material.dart';
import 'package:todo_in_flutter/constant/my_themes.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.lable, required this.onTap});

  // vaar
  final String lable;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Text(
          lable,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
