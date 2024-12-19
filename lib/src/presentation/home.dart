import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controller/currency_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CurrencyController controller = CurrencyController();

  @override
  void initState() {
    super.initState();
    controller.topController.addListener(controller.onTopValueChanged);
    controller.bottomController.addListener(controller.onBottomValueChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildCurrencyField({
    required TextEditingController textController,
    required String selectedCurrency,
    required Function(String) onCurrencyChanged,
    required bool isTop,
  }) {
    return TextFormField(
      controller: textController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onTap: () {
        controller.isConvertingTop = isTop;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.white,
        suffixIcon: PopupMenuButton<String>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedCurrency,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
              const SizedBox(width: 8),
            ],
          ),
          onSelected: onCurrencyChanged,
          itemBuilder: (BuildContext context) => controller.currencies
              .map(
                (currency) => PopupMenuItem(
                  value: currency['code'],
                  child: Text('${currency['code']} - ${currency['name']}'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: SvgPicture.asset(
                    AppImage.arrows,
                    package: AppImage.packageName,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Exchange',
                  style: AppTheme.theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 340,
              height: 320,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildCurrencyField(
                        textController: controller.topController,
                        selectedCurrency: controller.topCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setTopCurrency(value)),
                        isTop: true,
                      ),
                      const SizedBox(height: 16),
                      _buildCurrencyField(
                        textController: controller.bottomController,
                        selectedCurrency: controller.bottomCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setBottomCurrency(value)),
                        isTop: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
