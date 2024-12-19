import 'package:flutter/material.dart';

import '../../design_system.dart';

class TextInputDs extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double height;
  final double width;
  final bool isFilled;
  final bool isPassword;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;

  const TextInputDs({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.height = 50,
    this.width = 303,
    this.isFilled = true,
    this.isPassword = false,
    this.onChanged,
    this.autovalidateMode,
    this.textInputType = TextInputType.text,
  });

  @override
  State<TextInputDs> createState() => _TextInputDsState();
}

class _TextInputDsState extends State<TextInputDs> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 3,
        child: TextFormField(
          keyboardType: widget.textInputType,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: theme.textTheme.bodyLarge,
            filled: widget.isFilled,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
