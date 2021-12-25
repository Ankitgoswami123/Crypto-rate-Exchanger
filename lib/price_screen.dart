
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io';
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  DropdownButton<dynamic> androidDropDownButton() {

    List<DropdownMenuItem<String>> dropDownmenuItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownmenuItems.add(newItem);
    }
    return DropdownButton<dynamic>(
      value: selectedCurrency,
      items: dropDownmenuItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            getData();
          },
        );
      },
    );
  }
  CupertinoPicker iosPicker(){
    List<Text> itemsList = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      itemsList.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
      },
      children: itemsList,
    );
  }

  Map <String,String> coinValues = {};
  bool isWaiting = false;
  void getData() async{
      isWaiting = true;
      try{
        var data = await CoinData().getCoinData(selectedCurrency);
        isWaiting = false;
        setState(() {
          coinValues = data;
        });
      }
      catch(e){
        print(e);

      }
  }
   @override
  void initState() {
    super.initState();
    getData();
  }
  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
                   makeCards(),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS?iosPicker():androidDropDownButton(),
          ),],
      ),
    );
  }
}
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String ? value;
  final String ? selectedCurrency;
  final String ? cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}