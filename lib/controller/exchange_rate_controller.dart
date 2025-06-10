import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ExchangeRateController {
  Dio dio = Dio();

  Future<double?> getExchangeRate() async {
    try {
      final response = await dio.get(
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json',
      );

      if (response.statusCode == 200) {
        var data = response.data['usd']['khr'];
        debugPrint('Exchange Rate from USD to KHR : $data RIEL');
        return data;
      }
    } catch (e) {
      debugPrint('Error fetching exchange rate: $e');
      return null;
    }
    return null;
  }
}
