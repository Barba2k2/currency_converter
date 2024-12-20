import 'dart:developer';

import 'package:flutter/material.dart';

import '../service/currency_service.dart';

class CurrencyController {
  final TextEditingController topController = TextEditingController();
  final TextEditingController bottomController = TextEditingController();
  final CurrencyService currencyService = CurrencyService();
  bool isConvertingTop = true;

  String _topCurrency = 'USD';
  String _bottomCurrency = 'BRL';
  List<Map<String, String>> _currencies = [];

  String get topCurrency => _topCurrency;
  String get bottomCurrency => _bottomCurrency;
  List<Map<String, String>> get currencies => _currencies;

  Future<void> loadCurrencies() async {
    try {
      final currenciesMap = await currencyService.getCurrencies();
      _currencies = currenciesMap.entries
          .map((entry) => {
                'code': entry.key,
                'name': entry.value,
              })
          .toList();
    } catch (e) {
      log('Erro ao carregar moedas: $e');
      // Em caso de erro, use uma lista padrão
      _currencies = [
        {'code': 'USD', 'name': 'US Dollar'},
        {'code': 'EUR', 'name': 'Euro'},
        {'code': 'BRL', 'name': 'Brazilian Real'},
      ];
    }
  }

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
      // Limitar o valor máximo para evitar estouro
      if (amount > 999999.99) {
        amount = 999999.99;
        if (isConvertingTop) {
          topController.text = amount.toStringAsFixed(2);
        } else {
          bottomController.text = amount.toStringAsFixed(2);
        }
      }

      final result = await currencyService.convertCurrency(from, to, amount);

      // Formatar o resultado para evitar números muito grandes
      if (isConvertingTop) {
        bottomController.text = result.toStringAsFixed(2);
      } else {
        topController.text = result.toStringAsFixed(2);
      }
    } catch (e) {
      log('Erro na conversão: $e');
      // Adicionar tratamento de erro aqui
      if (isConvertingTop) {
        bottomController.text = '0.00';
      } else {
        topController.text = '0.00';
      }
    }
  }

  void dispose() {
    topController.dispose();
    bottomController.dispose();
  }
}
