import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:simple_form/screens/ordersList.dart';

void main() {
  runApp(BuyerProfile());
}

class BuyerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BuyerProfilePage(),
      // routes: <String, WidgetBuilder>{
      //   '/orders': (BuildContext context) => new OrdersPage()
      // },
    );
  }
}

class BuyerProfilePage extends StatefulWidget {
  BuyerProfilePage({Key key}) : super(key: key);

  @override
  _BuyerProfileState createState() => _BuyerProfileState();
}

class UserData {
  TextEditingController _name = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
}

class _BuyerProfileState extends State<BuyerProfilePage> {
  UserData _updateData = new UserData();

  static var userData;
  static var orders;
  bool _validate;

  @override
  void initState() {
    _getUserInfo();
    // reloadUser();
    _countOrders();
    // updateProfile();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String token = localStorage.getString('bigStore.jwt');
    var userJson = localStorage.getString('bigStore.user');
    var user = json.decode(userJson);
    // int id = user["id"];

    // String _url = "http://localhost:8000/api/users/$id";
    // await http.get(_url, headers: {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token',
    // });
    setState(() {
      userData = user;
    });
    print(userData);
  }

  // void reloadUser() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   String token = localStorage.getString('bigStore.jwt');
  //   var userJson = localStorage.getString('bigStore.user');
  //   var user = json.decode(userJson);
  //   int id = user["id"];
  //   String _url = "http://localhost:8000/api/users/$id";

  //   await http.get(_url, headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   });
  // }

  void _countOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    String _url = 'http://localhost:8000/api/orders';
    var response = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var body = json.decode(response.body);
    // print(body.toString());
    setState(() {
      orders = body.length;
    });
    print(orders);
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
    await http
        .patch(_url, body: data, headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        })
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  Column _buildNameResponse(
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
                IconButton(
                    icon: Icon(icon),
                    color: Colors.grey[500],
                    onPressed: () {
                      this._updateData._name.text = content;
                      _displayNameDialog(context);
                    })
              ],
            ))
      ],
    );
  }

  Column _buildPhoneResponse(
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
                IconButton(
                    icon: Icon(icon),
                    color: Colors.grey[500],
                    onPressed: () {
                      this._updateData._phoneNumber.text = content;
                      _displayPhoneDialog(context);
                    })
              ],
            ))
      ],
    );
  }

  _displayNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update name'),
            content: TextField(
              controller: this._updateData._name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Buyer's name",
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                // errorText: _validate ?? 'Name should not be empty'
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  // setState(() {
                  //   // this._updateData._name.text.isEmpty
                  //   //     ? _validate = true
                  //   //     : _validate = false;
                  //   _validate = this._updateData._name.text.isEmpty;
                  // });
                  updateProfile();
                  // reloadUser();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayPhoneDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update number'),
            content: TextField(
              controller: this._updateData._phoneNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Buyer's phone number",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  updateProfile();
                  // reloadUser();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
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

  Widget titleSection = Container(
    margin: const EdgeInsets.only(left: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            'Buyer',
            style: TextStyle(
                fontSize: 36.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200),
          ),
        )
      ],
    ),
  );

  // Widget emailSection = Container(
  //     margin: const EdgeInsets.all(20.0),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Container(
  //                 padding: const EdgeInsets.only(bottom: 8.0),
  //                 child: Text(
  //                   'Email',
  //                   style: TextStyle(color: Colors.grey[500]),
  //                 ),
  //               ),
  //               Text(
  //                 userData != null ? userData['email'] : "",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ));

  Column _buildEmailResponse(
      BuildContext context, String title, String content) {
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
              ],
            ))
      ],
    );
  }

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
          child: Text(
            'Save changes',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget ordersSection = Container(
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
                      'Number of orders',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  Text(
                    orders.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              child: Text("View"),
              onTap: () {
                // Navigator.of(context).pushNamed('/orders');
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => OrdersPage()));
              },
            )
          ],
        ));

    return Scaffold(
        body: ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
      headerSection,
      titleSection,
      _buildNameResponse(context, 'Name',
          userData != null ? userData['name'] : "", Icons.edit),
      // emailSection,
      _buildEmailResponse(
          context, 'Email', userData != null ? userData['email'] : ""),
      // _buildResponse(context, 'Email',
      //     userData != null ? userData['email'] : "", Icons.edit),
      ordersSection,
      _buildPhoneResponse(
          context,
          'Phone Number',
          // userData['phoneNumber'] ?? "N/A",
          "N/A",
          Icons.edit),
      footerSection
    ]));
  }
}
