import 'package:flutter/material.dart';
import 'package:simple_form/buyer_signup.dart';
import 'package:simple_form/vendor_signup.dart';

void main() => runApp(SignUp());

class SignUp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUpPage> {
  var _currentPage = 0;
  var _pages = [BuyerSignupPage(), VendorSignupPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sign Up",
        home: Scaffold(
            body: Center(child: _pages.elementAt(_currentPage)),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_box), title: Text("Buyer")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Vendor")),
                ],
                currentIndex: _currentPage,
                fixedColor: Colors.white,
                backgroundColor: Colors.green,
                onTap: (int inIndex) {
                  setState(() {
                    _currentPage = inIndex;
                  });
                })));
  }
}
