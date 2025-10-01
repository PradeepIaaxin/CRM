import 'package:flutter/material.dart';

class RoundedFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;

  const RoundedFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      shape: const CircleBorder(),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}
