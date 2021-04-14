import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'Mumbai', selectedCurrency2 = 'Mumbai';
  List<String> messageWidgets = [""];
  int mlen = 1;
  DropdownButton<String> androidDropdown(int a) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(
          currency,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: a == 1 ? selectedCurrency : selectedCurrency2,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          if (a == 1) {
            selectedCurrency = value;
          } else {
            selectedCurrency2 = value;
          }
        });
      },
    );
  }

  CupertinoPicker iOSPicker(int a) {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(
          currency,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.yellow[700],
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          if (a == 1) {
            selectedCurrency = currenciesList[selectedIndex];
          } else {
            selectedCurrency2 = currenciesList[selectedIndex];
          }
        });
      },
      children: pickerItems,
    );
  }

  String value = '?';
  Map<String, String> coinValues = {};
  bool isWaiting = false;
  //TODO 7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. Hint: You'll need a ternary operator.

  //TODO 6: Update this method to receive a Map containing the crypto:price key value pairs. Then use that map to update the CryptoCards.
  Future<String> Add(String a, String b) async {
    http.Response response = await http.post(
      Uri.http('127.0.0.1:8000', 'asl-to-text/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'from': a,
        'to': b,
      }),
    );
    return response.body;
  }

  @override
  void initState() {
    super.initState();
  }

  //TODO: For bonus points, create a method that loops through the cryptoList and generates a CryptoCard for each.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Text(
          'Minimum Cost Finder',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(children: [
              ListView.builder(
                padding: EdgeInsets.fromLTRB(50, 250, 50, 50),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: mlen,
                itemBuilder: (context, index) {
                  return Text(
                    messageWidgets[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  );
                },
              ),
            ]),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    List<String> ans = [];
                    dynamic Response =
                        await Add(selectedCurrency, selectedCurrency2);
                    Map<dynamic, dynamic> parse = jsonDecode(Response);
                    print(parse["path"]);
                    String x = "";
                    int cnt = 0;
                    for (var i in parse["path"]) {
                      if (cnt == 0) {
                        x += currenciesList[i];
                      } else {
                        x += ' --${parse['edge'][cnt]}--> ' + currenciesList[i];
                      }
                      cnt++;
                    }

                    // int cnt = 0;
                    // for (var i in parse["path"]) {
                    //   if (cnt == 0) {
                    //     ans.add(currenciesList[i]);
                    //   } else {
                    //     ans.add('|');
                    //     ans.add('${parse["edge"][cnt]}');
                    //     ans.add('|');
                    //     ans.add('V');
                    //     ans.add(currenciesList[i]);
                    //   }
                    //   cnt++;
                    // }

                    ans.add(x);
                    ans.add('\n');
                    ans.add("You Need to Pay Rs.${parse["cost"][0]}K!");
                    print(parse['edge']);
                    setState(
                      () {
                        messageWidgets = ans;
                        mlen = ans.length;
                      },
                    );
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          height: 50.0,
                          width: 70.0,
                          // width: MediaQuery.of(context).size.width,
                          // color: Colors.yellow.shade600,
                          padding: const EdgeInsets.all(8),

                          child: Center(
                            child: Text(
                              'From',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.yellow[700],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20),
                          height: 70.0,
                          width: 70.0,
                          // width: MediaQuery.of(context).size.width,
                          // color: Colors.yellow.shade600,
                          padding: const EdgeInsets.all(8),

                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.yellow[700],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20),
                          height: 50.0,
                          width: 70.0,
                          // width: MediaQuery.of(context).size.width,
                          // color: Colors.yellow.shade600,
                          padding: const EdgeInsets.all(8),

                          child: Center(
                            child: Text(
                              'To',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.yellow[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(children: [
                  Container(
                    height: 150.0,
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    color: Colors.yellow[700],
                    child: Platform.isIOS ? iOSPicker(1) : androidDropdown(1),
                  ),
                  Container(
                    height: 150.0,
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    color: Colors.yellow[700],
                    child: Platform.isIOS ? iOSPicker(2) : androidDropdown(2),
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
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
