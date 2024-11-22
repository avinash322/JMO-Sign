import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double width;
  final TextStyle textStyle;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.height = 50.0,
    this.width = double.infinity,
    this.textStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
