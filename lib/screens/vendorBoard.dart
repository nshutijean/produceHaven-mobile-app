import 'package:flutter/material.dart';
import 'package:simple_form/screens/productsList.dart';
import 'package:simple_form/screens/uploadProduct.dart';
import 'package:simple_form/screens/vendor_profile.dart';

void main() => runApp(VendorBoard());

class VendorBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: VendorBoardPage(),
    );
  }
}

class VendorBoardPage extends StatefulWidget {
  VendorBoardPage({Key key}) : super(key: key);

  @override
  _VendorBoardState createState() => _VendorBoardState();
}

class _VendorBoardState extends State<VendorBoardPage> {
  var _currentPage = 0;
  var _pages = [UploadProduct(), VendorProfile(), ProductsPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "VendorBoard",
        home: Scaffold(
            body: Center(child: _pages.elementAt(_currentPage)),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.file_upload), title: Text("Upload")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Profile")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), title: Text("Products")),
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
