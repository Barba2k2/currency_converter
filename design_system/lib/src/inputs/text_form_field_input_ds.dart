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
  final InputBorder? focusedBorder;

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
    this.focusedBorder,
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
            focusedBorder: widget.focusedBorder,
            hintText: widget.label,
            hintStyle: theme.textTheme.bodyLarge,
            filled: widget.isFilled,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: DropdownButton<String>(
                value: widget.selectedCurrency,
                dropdownColor: AppColors.white,
                isExpanded: false,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                underline: Container(),
                alignment: AlignmentDirectional.centerEnd,
                onChanged: (String? newValue) {
                  if (newValue != null && widget.onCurrencyChanged != null) {
                    widget.onCurrencyChanged!(newValue);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return widget.itemBuilder(context).whereType<PopupMenuItem<String>>().map<Widget>(
                    (PopupMenuItem<String> item) {
                      final currencyCode = item.value?.split(' - ').first ?? '';
                      return Center(
                        child: Text(
                          currencyCode,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ).toList();
                },
                items: widget.itemBuilder(context).whereType<PopupMenuItem<String>>().map(
                  (PopupMenuItem<String> item) {
                    return DropdownMenuItem<String>(
                      value: item.value,
                      child: Text(item.value ?? ''),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
