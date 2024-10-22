import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
import 'package:simple_form/main.dart';
import 'screens/buyerBoard.dart';

import 'login.dart';

void main() => runApp(BuyerSignup());

class BuyerSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: BuyerSignupPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new FormPage(),
        '/': (BuildContext context) => new HomePage()
      },
    );
  }
}

class BuyerSignupPage extends StatefulWidget {
  @override
  BuyerSignupPage({Key key}) : super(key: key);
  _BuyerSignupPageState createState() => new _BuyerSignupPageState();
}

class SignUpData {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
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

class _BuyerSignupPageState extends State<BuyerSignupPage> {
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
      'c_password': this._signUpData._confirmPass.text
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);
    if (body['token'] != null) {
      //Save and retrieve user's token from localstorage
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('bigStore.jwt', body['token']);
      // localStorage.setString('bigStore.user', json.encode(body['user']));
      // var userJson = localStorage.getString('bigStore.user');
      // var user = json.decode(userJson);
      // print(user['id']);

      //message showing dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.green, style: BorderStyle.solid, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              child: Text(
                body['message'],
              ),
            ),
            title: Text(
              'Success',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.green),
                  ))
            ],
          );
        },
      );

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => BuyerBoardPage()));
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
            //Buyer text title
            Container(
              // padding: EdgeInsets.fromLTRB(0.0, 0.0, 120.0, 0.0),
              margin: EdgeInsets.only(top: 70.0, left: 40.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Buyer",
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
                          // _formKey.currentState.reset();
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
