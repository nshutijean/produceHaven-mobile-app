import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
import 'package:simple_form/main.dart';
import 'screens/vendorBoard.dart';

import 'login.dart';

void main() => runApp(VendorSignup());

class VendorSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: VendorSignupPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new FormPage(),
        '/': (BuildContext context) => new HomePage()
      },
    );
  }
}

class VendorSignupPage extends StatefulWidget {
  @override
  VendorSignupPage({Key key}) : super(key: key);
  _VendorSignupPageState createState() => new _VendorSignupPageState();
}

class SignUpData {
  // String name = "";
  // String email = "";
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _subAccountId = TextEditingController();
}

class RegexValidation {
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
}

class _VendorSignupPageState extends State<VendorSignupPage> {
  SignUpData _signUpData = new SignUpData();
  RegexValidation _regexValidation = new RegexValidation();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading = false;

  _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': this._signUpData._name.text,
      'email': this._signUpData._email.text,
      'password': this._signUpData._pass.text,
      'c_password': this._signUpData._confirmPass.text,
      'phoneNumber': this._signUpData._phoneNumber.text,
      'subAccountId': this._signUpData._subAccountId.text,
    };

    var res = await CallApi().postData(data, 'vendor');
    var body = json.decode(res.body);
    if (body['token'] != null) {
      //Save and retrieve user's token from localstorage
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('bigStore.jwt', body['token']);
      localStorage.setString('bigStore.user', json.encode(body['user']));
      var userJson = localStorage.getString('bigStore.user');
      var user = json.decode(userJson);
      print(user['id']);

      //Go to either screen(profile or QRscanner) in VendorBoard route after registration
      // if(user['isAdmin'] == 0) {

      // } else {

      // }
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => VendorBoardPage()));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Signup form"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Vendor text title
            Container(
              // padding: EdgeInsets.fromLTRB(0.0, 0.0, 100.0, 0.0),
              margin: EdgeInsets.only(top: 70.0, left: 40.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Vendor",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic),
                // textAlign: TextAlign.left,
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0),
              child: Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    //Names textfield
                    TextFormField(
                      controller: this._signUpData._name,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        return value.isEmpty ? "Name is required" : null;
                      },
                      onSaved: (String value) {
                        this._signUpData._name.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your name",
                          labelText: "Name",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    //Email textfield
                    TextFormField(
                      controller: this._signUpData._email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String value) {
                        RegExp regExp = new RegExp(this._regexValidation.p);

                        if (!regExp.hasMatch(value)) {
                          return "Email is not valid";
                        }
                        if (value.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this._signUpData._email.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your email address",
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    //Phone number textfield
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      controller: this._signUpData._phoneNumber,
                      keyboardType: TextInputType.phone,
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.length < 10) {
                          return "At least 10 characters are required";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this._signUpData._phoneNumber.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          labelText: "Phone number",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //SubaccountID textfield
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      controller: this._signUpData._subAccountId,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "SubaccountID is required";
                        }
                        if (value.length < 35) {
                          return "At least 35 characters are required";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this._signUpData._subAccountId.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Sub_ID",
                          labelText: "SubAccount ID",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    //Password textfield
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      controller: this._signUpData._pass,
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "At least 6 characters are required";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this._signUpData._pass.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    //Confirm password textfield
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      controller: this._signUpData._confirmPass,
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Password is required";
                        }
                        if (value != this._signUpData._pass.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this._signUpData._confirmPass.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Confirm your password",
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      child: Text(
                        _isLoading ? "Signing up..." : "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _isLoading ? null : _handleLogin();
                        // _formKey.currentState.reset();
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _formKey.currentState.reset();
                        }
                      },
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already registered?',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/');
                          },
                          child: Text(
                            'Go Home',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
