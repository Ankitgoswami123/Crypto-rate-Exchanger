import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey ='8C745160-5A70-41CC-A151-3F2607382E48';



class CoinData{
  Future getCoinData(String selectedCurrency)async{
    Map<String,String> cryptoPrices ={};
    for(String crypto in cryptoList){
      String requestUrl = '$coinApiUrl/$crypto/$selectedCurrency?apiKey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestUrl));
      if(response.statusCode == 200){
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      }
      else{
        print(response.statusCode);
        throw 'problem with the get request';
      }

    }
    return cryptoPrices;
  }
}








const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

