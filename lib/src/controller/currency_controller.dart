import 'package:flutter/material.dart';

import '../service/currency_service.dart';

class CurrencyController {
  final TextEditingController topController = TextEditingController();
  final TextEditingController bottomController = TextEditingController();
  final CurrencyService currencyService = CurrencyService();
  bool isConvertingTop = true;

  String _topCurrency = 'USD';
  String _bottomCurrency = 'BRL';

  String get topCurrency => _topCurrency;
  String get bottomCurrency => _bottomCurrency;

  final List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'Dólar Americano'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'BRL', 'name': 'Real Brasileiro'},
    {'code': 'GBP', 'name': 'Libra Esterlina'},
    {'code': 'JPY', 'name': 'Iene Japonês'},
  ];

  void setTopCurrency(String value) {
    _topCurrency = value;
    // Reconverte usando o valor atual do campo superior
    if (topController.text.isNotEmpty) {
      _convertCurrency(
        double.tryParse(topController.text) ?? 0,
        _topCurrency,
        _bottomCurrency,
      );
    }
  }

  void setBottomCurrency(String value) {
    _bottomCurrency = value;
    // Reconverte usando o valor atual do campo superior
    if (topController.text.isNotEmpty) {
      _convertCurrency(
        double.tryParse(topController.text) ?? 0,
        _topCurrency,
        _bottomCurrency,
      );
    }
  }

  void onTopValueChanged() {
    if (isConvertingTop && topController.text.isNotEmpty) {
      _convertCurrency(
        double.tryParse(topController.text) ?? 0,
        _topCurrency,
        _bottomCurrency,
      );
    }
  }

  void onBottomValueChanged() {
    if (!isConvertingTop && bottomController.text.isNotEmpty) {
      _convertCurrency(
        double.tryParse(bottomController.text) ?? 0,
        _bottomCurrency,
        _topCurrency,
      );
    }
  }

  Future<void> _convertCurrency(double amount, String from, String to) async {
    try {
      final result = await currencyService.convertCurrency(from, to, amount);

      if (isConvertingTop) {
        bottomController.text = result.toStringAsFixed(2);
      } else {
        topController.text = result.toStringAsFixed(2);
      }
    } catch (e) {
      print('Erro na conversão: $e');
    }
  }

  void dispose() {
    topController.dispose();
    bottomController.dispose();
  }
}
