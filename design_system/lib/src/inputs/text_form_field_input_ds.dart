import 'package:flutter/material.dart';

import '../../design_system.dart';

class TextInputDs extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final double height;
  final double width;
  final bool isFilled;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final VoidCallback onTap;
  final String selectedCurrency;
  final Function(String)? onCurrencyChanged;
  final List<PopupMenuEntry<String>> Function(BuildContext) itemBuilder;

  const TextInputDs({
    super.key,
    required this.label,
    this.controller,
    this.height = 50,
    this.width = 303,
    this.isFilled = true,
    this.onChanged,
    this.textInputType = const TextInputType.numberWithOptions(decimal: true),
    required this.onTap,
    required this.selectedCurrency,
    this.onCurrencyChanged,
    required this.itemBuilder,
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
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: theme.textTheme.bodyLarge,
            filled: widget.isFilled,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: PopupMenuButton<String>(
              icon: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.selectedCurrency,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
              onSelected: widget.onCurrencyChanged,
              itemBuilder: widget.itemBuilder,
            ),
          ),
        ),
      ),
    );
  }
}
