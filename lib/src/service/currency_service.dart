import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String baseUrl = 'https://api.frankfurter.app';

  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/latest?amount=$amount&from=$from&to=$to'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log('Data: ${data.toString()}');

        // Garantir que o valor retornado seja um double válido
        final rate = data['rates'][to];
        if (rate is int) {
          return rate.toDouble();
        } else if (rate is double) {
          return rate;
        }
        return 0.0;
      } else {
        throw Exception('Falha ao converter moeda');
      }
    } catch (e) {
      log('Erro na conversão: $e');
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    final response = await http.get(
      Uri.parse('$baseUrl/latest?from=$baseCurrency'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar taxas');
    }
  }

  Future<Map<String, String>> getCurrencies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/currencies'),
    );

    if (response.statusCode == 200) {
      return Map<String, String>.from(
        json.decode(response.body),
      );
    } else {
      throw Exception('Falha ao carregar moedas');
    }
  }
}
