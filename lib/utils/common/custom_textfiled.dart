import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfomrfiledbox extends StatefulWidget {
  final TextEditingController controller;
  final Color? color;
  final Decoration? decoration;
  final int? length;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hinttext;
  final Icon? icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;

  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final bool readOnly;
  final Function()? onTap;

  const MyTextfomrfiledbox({
    super.key,
    required this.controller,
    this.color,
    this.decoration,
    this.keyboardType,
    this.icon,
    this.hinttext,
    this.suffixIcon,
    this.obscureText = false,
    this.length,
    this.maxLines = 1,
    this.enable,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<MyTextfomrfiledbox> createState() => _MyTextFormFieldBoxState();
}

class _MyTextFormFieldBoxState extends State<MyTextfomrfiledbox> {
  late FocusNode _focusNode;
  Color _currentBorderColor = Color(0xFF4752EB);

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _currentBorderColor = _focusNode.hasFocus
            ? Color(0xFF4752EB)
            : Color(0xFF4752EB);
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      maxLength: widget.length,
      maxLines: widget.maxLines,
      enabled: widget.enable ?? true,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: widget.color),
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hinttext,
        labelText: widget.hinttext,
        fillColor: Colors.white,
        filled: true,
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1.5, color: _currentBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.0, color: _currentBorderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _currentBorderColor),
        ),
      ),
    );
  }
}
