import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final String texxt;
  final Color txtcolor;
  final Function() onpressed;
  final BorderRadius? borderRadius;
  final bool isLoading; // new property

  const Button({
    super.key,
    required this.color,
    required this.onpressed,
    required this.texxt,
    required this.width,
    required this.height,
    required this.txtcolor,
    this.borderRadius,
    this.isLoading = false, // default false
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : widget.onpressed, // disable while loading
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  widget.texxt,
                  style: TextStyle(
                    color: widget.txtcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
