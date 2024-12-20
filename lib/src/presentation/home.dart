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
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await controller.loadCurrencies();
    if (mounted) setState(() {});
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
    required String label,
    required bool isTop,
  }) {
    return TextInputDs(
      controller: textController,
      onTap: () {
        controller.isConvertingTop = isTop;
      },
      itemBuilder: (BuildContext context) => controller.currencies
          .map(
            (currency) => PopupMenuItem(
              value: currency['code'],
              child: Text('${currency['code']} - ${currency['name']}'),
            ),
          )
          .toList(),
      isFilled: true,
      onCurrencyChanged: onCurrencyChanged,
      label: label,
      selectedCurrency: selectedCurrency,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
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
              spacing: 8,
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
              width: 360,
              height: 380,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.gray400,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Conversor de moedas',
                              style: AppTheme.theme.textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            'Digite o valor escolha as moedas de conversão',
                            style: AppTheme.theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildCurrencyField(
                        textController: controller.topController,
                        selectedCurrency: controller.topCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setTopCurrency(value)),
                        isTop: true,
                        label: '\$ 100.00',
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            AppImage.arrowsCurrency,
                            package: AppImage.packageName,
                          ),
                        ),
                      ),
                      _buildCurrencyField(
                        textController: controller.bottomController,
                        selectedCurrency: controller.bottomCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setBottomCurrency(value)),
                        isTop: false,
                        label: 'R\$ 100.00',
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
