import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String text;
  final Color txtcolor;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const Button({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.text,
    required this.txtcolor,
    required this.onPressed,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: txtcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
