import 'package:flutter/material.dart';
import 'package:simple_form/main.dart';
// import 'package:simple_form/buyer_signup.dart';
import 'package:simple_form/screens/signup_all.dart';
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
  String userName = "";
  String password = "";
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
  LoginData _loginData = new LoginData();
  RegexValidation _regexValidation = new RegexValidation();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  RegExp regExp = new RegExp(this._regexValidation.p);
                  if (!regExp.hasMatch(value)) {
                    return "Email is not valid";
                  }
                  if (value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._loginData.userName = value;
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
                  this._loginData.password = value;
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
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print("Username: ${_loginData.userName}");
                    print("Password: ${_loginData.password}");
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
}
