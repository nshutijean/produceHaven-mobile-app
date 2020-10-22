import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
import 'package:simple_form/main.dart';
import 'package:simple_form/screens/buyerBoard.dart';
// import 'package:simple_form/screens/buyer_profile.dart';
// import 'package:simple_form/buyer_signup.dart';
import 'package:simple_form/screens/signup_all.dart';
import 'package:simple_form/screens/vendorBoard.dart';
// import 'package:simple_form/vendor_signup.dart';
// import 'regex.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: FormPage(),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignUpPage(),
        '/': (BuildContext context) => new HomePage()
      },
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  FormPage({Key key}) : super(key: key);
  _FormPageState createState() => new _FormPageState();
}

class LoginData {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
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

class _FormPageState extends State<FormPage> {
  bool _isLoading = false;

  LoginData _loginData = new LoginData();
  RegexValidation _regexValidation = new RegexValidation();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _showMessage(message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Login Page"),
      // ),
      body: SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.fromLTRB(50.0, 170.0, 50.0, 0),
          child: Form(
            key: this._formKey,
            child: Column(children: [
              TextFormField(
                controller: this._loginData._email,
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  RegExp regExp = new RegExp(this._regexValidation.p);
                  if (value.isEmpty) {
                    return "Email must not be empty";
                  } else if (!regExp.hasMatch(value)) {
                    return "Email is not valid";
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._loginData._email.text = value;
                },
                decoration: InputDecoration(
                    hintText: "john@doe.com",
                    labelText: "Email Address",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                controller: this._loginData._password,
                obscureText: true,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Password must not be empty";
                  }
                  if (value.length < 6) {
                    return "Password must have 6 characters";
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._loginData._password.text = value;
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              SizedBox(
                height: 40.0,
              ),
              RaisedButton(
                child: Text(
                  _isLoading ? "Signing In" : "Sign in",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _isLoading
                      ?
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       content: Text("Failed to sign-in"),
                      //     );
                      //   })
                      null
                      : _login();
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // print("Username: ${_loginData._userName.text}");
                    // print("Password: ${_loginData._password.text}");
                    // Scaffold.of(context)
                    //     .showSnackBar(SnackBar(content: Text('Processing...')));

                  }
                },
                color: Colors.green,
                disabledColor: Colors.grey,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Not Registered?'),
                  SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
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
            ]),
          ),
        ),
      ),
    );
  }

  void _login() async {
    LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      backgroundColor: Colors.white,
    );
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': this._loginData._email.text,
      'password': this._loginData._password.text
    };

    //api login call from the backend
    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);

    //checks if user is authorized
    if (body['token'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('bigStore.jwt', body['token']);
      localStorage.setString('bigStore.user', json.encode(body['user']));

      //retrieves user data and converts to json
      var userJson = localStorage.getString('bigStore.user');
      var user = json.decode(userJson);
      // print(user['is_admin']);

      // Route goes to its respective user(buyer or vendor)
      if (user['is_admin'] == 0) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => BuyerBoardPage()));
      } else if (user['is_admin'] == 1) {
        //trying to add a progressing bar while signing-in 😪
        // Timer.periodic(new Duration(seconds: 1), (timer) {
        //   return showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
        //         title: Text("Signed in"),
        //         // content: LinearProgressIndicator(),
        //       );
        //     },
        //   );
        // });
        // Timer.run(() {
        //   return showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         shape: RoundedRectangleBorder(
        //             side: BorderSide(
        //                 color: Colors.green,
        //                 style: BorderStyle.solid,
        //                 width: 1.5),
        //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
        //         title: Text("Signed in"),
        //         // content: LinearProgressIndicator(),
        //       );
        //     },
        //   );
        // });
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => VendorBoardPage()));
      }
    } else {
      //retrieve error message from API, if inputs are not empty
      if (this._loginData._email.text.isNotEmpty ||
          this._loginData._password.text.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              content: Container(
                child: Text(
                  // this._loginData._email.text.isEmpty ||
                  //         this._loginData._password.text.isEmpty
                  //     ? "Please input missing values"
                  //     :
                  'Your email/password is incorrect or you do not have an account',
                ),
              ),
              title: Text(
                // 'Error: ' + body['error'],
                // this._loginData._email.text.isEmpty ||
                //         this._loginData._password.text.isEmpty
                //     ? "Error: ${body['errors']}"
                //     :
                "Error: ${body['error']}",
                style: TextStyle(color: Colors.red),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            );
          },
        );
      }
    }
    // print(body);

    setState(() {
      _isLoading = false;
    });
  }
}
