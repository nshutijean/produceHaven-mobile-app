import 'package:flutter/material.dart';
import 'package:simple_form/login.dart';
import 'package:simple_form/buyer_signup.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:simple_form/screens/signup_all.dart';
// import 'regex.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new FormPage(),
        // '/signUp': (BuildContext context) => new SignUpPage()
        '/signup': (BuildContext context) => new SignUpPage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  // HomePage (Key key): super(key: key);
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
        url: "https://produce-haven.herokuapp.com",
        androidToolbarColor: Colors.deepPurple);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Produce Haven Trade"), backgroundColor: Colors.green),
        body: new Container(
          padding: EdgeInsets.fromLTRB(40.0, 200.0, 40.0, 0.0),
          child: Center(
            child: Column(
              children: <Widget>[
                // Logo
                Container(),
                Container(
                  height: 50.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    shadowColor: Colors.transparent,
                    color: Colors.green,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2.0,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  height: 50.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    shadowColor: Colors.transparent,
                    color: Colors.green,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Center(
                        child: Text(
                          'JOIN US',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              wordSpacing: 5.0,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () => openBrowserTab(),
                      child: Text(
                        'Visit the web',
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
