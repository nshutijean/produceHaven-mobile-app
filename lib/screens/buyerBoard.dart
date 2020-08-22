import 'package:flutter/material.dart';
import 'package:simple_form/scanner/scan.dart';

import 'buyer_profile.dart';

void main() => runApp(BuyerBoard());

class BuyerBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: BuyerBoardPage(),
    );
  }
}

class BuyerBoardPage extends StatefulWidget {
  BuyerBoardPage({Key key}) : super(key: key);

  @override
  _BuyerBoardState createState() => _BuyerBoardState();
}

class _BuyerBoardState extends State<BuyerBoardPage> {
  var _currentPage = 0;
  var _pages = [BuyerProfile(), Scan()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "UserBoard",
        home: Scaffold(
            body: Center(child: _pages.elementAt(_currentPage)),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Profile")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.scanner), title: Text("Scan Code")),
                ],
                currentIndex: _currentPage,
                fixedColor: Colors.green,
                onTap: (int inIndex) {
                  setState(() {
                    _currentPage = inIndex;
                  });
                })));
  }
}
