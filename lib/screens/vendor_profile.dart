import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_form/api/api.dart';
import 'package:simple_form/screens/productsList.dart';
import 'package:simple_form/screens/signup_all.dart';
import 'package:simple_form/screens/vendorBoard.dart';

import '../login.dart';

void main() {
  runApp(VendorProfile());
}

class VendorProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: VendorProfilePage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new FormPage(),
        '/bottomNav': (BuildContext context) => new VendorBoardPage()
      },
    );
  }
}

class VendorProfilePage extends StatefulWidget {
  VendorProfilePage({Key key}) : super(key: key);

  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class UserData {
  TextEditingController _name = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
}

class _VendorProfileState extends State<VendorProfilePage> {
  UserData _updateData = new UserData();

  static var userData;
  static var uploads;

  @override
  void initState() {
    // _getUserInfo();
    reloadUser();
    _countUploads();
    // updateProfile();
    super.initState();
  }

  // void _getUserInfo() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   // String token = localStorage.getString('bigStore.jwt');
  //   var userJson = localStorage.getString('bigStore.user');
  //   var user = json.decode(userJson);

  //   setState(() {
  //     userData = user;
  //   });
  //   print(userData);
  // }

  void reloadUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    var userJson = localStorage.getString('bigStore.user');
    var user = json.decode(userJson);
    int id = user["id"];

    String _url = "http://localhost:8000/api/users/$id";
    print(_url);

    var res = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    var body = json.decode(res.body);
    print(body);
    setState(() {
      userData = body;
    });
  }

  void _countUploads() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    String _url = 'http://localhost:8000/api/showWithAuth';
    var response = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var body = json.decode(response.body);
    print(body.toString());
    setState(() {
      uploads = body.length;
    });
    print(uploads);
  }

  void _logout() async {
    // revoke token from server(logout)
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    String user = localStorage.getString('bigStore.user');

    String _url = 'http://localhost:8000/api/logout';

    var res = await http.get(_url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    // var res = await CallApi().getData('logout');

    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      //remove the user
      localStorage.remove('bigStore.user');
      //remove the token
      localStorage.remove('bigStore.jwt');
      //UX message from API
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
      Navigator.pushNamed(context, '/login');

      // Navigator.push(
      //     context, new MaterialPageRoute(builder: (context) => SignUpPage()));
      // Navigator.pop(context,
      //     new MaterialPageRoute(builder: (context) => VendorBoardPage()));
      // Navigator.popAndPushNamed(
      //     context, MaterialPageRoute(builder: (context) => VendorBoardPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }

  //it's updating in the DB but not automatically changing on the screen
  void updateProfile() async {
    var data = {
      'name': this._updateData._name.text,
      'phoneNumber': this._updateData._phoneNumber.text
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    var userJson = localStorage.getString('bigStore.user');
    var user = json.decode(userJson);
    int id = user["id"];
    // print(id);
    String _url = "http://localhost:8000/api/users/$id";
    var res = await http.patch(_url, body: data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var body = json.decode(res.body);
    print(body);

    //status checking, error catching
    if (res.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
      reloadUser();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }

  Column _buildProfileResponse(
      BuildContext context, String title, String content, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      Text(
                        content,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.grey,
                )
              ],
            ))
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Profile'),
            content: Column(
              // padding: EdgeInsets.only(bottom: 5.0),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: this._updateData._name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Buyer's name",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      // errorText: _validate ?? 'Name should not be empty'
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: this._updateData._phoneNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Buyer's phone number",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      // errorText: _validate ?? 'Name should not be empty'
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      updateProfile();
                      // reloadUser();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget titleSection = Container(
    margin: const EdgeInsets.only(left: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            'Vendor',
            style: TextStyle(
                fontSize: 36.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget headerSection = Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // add an action to this(onTap)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0))),
                child: InkWell(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    _logout();
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'Profile',
                style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              )
            ],
          )
        ],
      ),
    );

    Widget uploadsSection = Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Number of uploads',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  Text(
                    uploads.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              child: Text('View'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ProductsPage()));
              },
            )
          ],
        ));

    Widget footerSection = Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.black,
              width: 2.0,
            ))),
            child: InkWell(
              child: Text(
                'Edit your profile',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                this._updateData._name.text = userData['name'];
                if (this._updateData._phoneNumber.text.isEmpty) {
                  this._updateData._phoneNumber.text = "N/A";
                } else {
                  this._updateData._phoneNumber.text = userData['phoneNumber'];
                }
                _displayDialog(context);
              },
            ),
          )
        ],
      ),
    );

    return Scaffold(
        body: ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
      headerSection,
      titleSection,
      _buildProfileResponse(context, 'Name',
          userData != 'null' ? userData['name'] : "", Icons.account_box),
      _buildProfileResponse(context, 'Email',
          userData != 'null' ? userData['email'] : "", Icons.email),
      // _buildResponse(context, 'Email',
      //     userData != null ? userData['email'] : "", Icons.edit),
      uploadsSection,
      _buildProfileResponse(
          context,
          'Phone Number',
          userData['phoneNumber'].toString() != 'null'
              ? userData['phoneNumber']
              : 'N/A',
          Icons.phone),
      footerSection
    ]));
  }
}
