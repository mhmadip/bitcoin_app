import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const BitcoinApp());
}

class Currency{
  String id;
  String symbol;
  String name;
  String price;
  Currency({required this.id, required this.symbol,required this.name,required this.price});

  factory Currency.fromJson(List<dynamic> json  ){
    final currency= json[0];
    return Currency(id: currency['id'], symbol: currency['symbol'],name: currency['name'],price: currency['price_usd']);
  }
}

Future<Currency> _fetchCurrency() async{
  final url='https://api.coinlore.net/api/ticker/?id=90';
  final response= await get(Uri.parse(url));
  print(response.body);
  if(response.statusCode==200){
    final jsonResponse= json.decode(response.body);
    return Currency.fromJson(jsonResponse);
  } else {
    throw Exception('Faild to fetch currency data');
  }
}

class BitcoinApp extends StatefulWidget {
  const BitcoinApp({Key? key}) : super(key: key);

  @override
  State<BitcoinApp> createState() => _BitcoinAppState();
}

class _BitcoinAppState extends State<BitcoinApp> {
  Currency? _currency;
  
  Future<void> _getPrice() async {
    final currency= await _fetchCurrency();
    setState(() {
      _currency= currency;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:Scaffold(appBar: AppBar(
        title: const Text('Bitcoin Price of Today!'),
      backgroundColor: Colors.orange,),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network('https://images.cointelegraph.com/cdn-cgi/image/format=auto,onerror=redirect,quality=90,width=717/https://s3.cointelegraph.com/uploads/2023-03/58153625-17ae-4b93-89c9-90076abb34f7.jpg'),
            TextButton(onPressed: (){_getPrice();},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
                child: const Text('Get Price :)',style: TextStyle(fontSize: 25),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
                    Text(_currency != null ? 'ID: ${_currency!.id}' : 'Something wrong :(',style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40), ),
                    Text(_currency != null ? 'Symbol: ${_currency!.symbol}' : 'Something wrong :(',style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40), ),
                    Text(_currency != null ? 'Name: ${_currency!.name}' : 'Something wrong :(',style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40), ),
                    Text(_currency != null ? _currency!.price : 'Something wrong :(',style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40), )

           ] ),
      )
      )
    );
  }
}


