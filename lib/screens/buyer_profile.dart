import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: BuyerProfile(),
  ));
}

class BuyerProfile extends StatefulWidget {
  BuyerProfile({Key key}) : super(key: key);

  @override
  _BuyerProfileState createState() => _BuyerProfileState();
}

class _BuyerProfileState extends State<BuyerProfile> {
  var orders;
  var userData;

  @override
  void initState() {
    _getUserInfo();
    _countOrders();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('bigStore.user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }

  void _countOrders() async {
    // var res = await CallApi().getData("orders-count");
    // var body = json.decode(res.body);
    // // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // // var token = localStorage.getString('bigStore.jwt');
    // if (body['token'] != null) {
    // setState(() {
    //   orders = body;
    //   print(orders);
    // });
    // }
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    String _url = 'http://localhost:8000/api/orders-count';
    var response = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var body = json.decode(response.body);
    // print(body.toString());
    setState(() {
      orders = body.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Logout and title
            Row(
              children: <Widget>[
                Text(
                  "Logout",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),

            // Name
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Name/s",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      userData != null ? userData['name'] : "",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),

                //edit icon which should have an onTap() or onPressed function to edit the text
                Column(
                  children: <Widget>[Icon(Icons.edit)],
                )
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            //email
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      userData != null ? userData['email'] : "",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),

                //edit icon which should have an onTap() or onPressed function to edit the text
                Column(
                  children: <Widget>[Icon(Icons.edit)],
                )
              ],
            ),
            SizedBox(
              height: 15.0,
            ),

            //number of orders
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Number of orders",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      orders.toString(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),

                //edit icon which should have an onTap() or onPressed function to edit the text
                Column(
                  children: <Widget>[
                    Text(
                      "View",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),

            //Password(probably not)
            // Row(
            //   children: <Widget>[
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: <Widget>[
            //         Text(
            //           "Number of orders",
            //           style: TextStyle(
            //               fontSize: 16.0, fontWeight: FontWeight.w300),
            //         ),
            //         Text(
            //           "3",
            //           style: TextStyle(
            //               fontSize: 16.0, fontWeight: FontWeight.w300),
            //         ),
            //       ],
            //     ),

            //     //edit icon which should have an onTap() or onPressed function to edit the text
            //     Column(
            //       children: <Widget>[
            //         Text(
            //           "View",
            //           style: TextStyle(
            //               fontSize: 15.0, fontWeight: FontWeight.w400),
            //         )
            //       ],
            //     )
            //   ],
            // )
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Text(
                  "Save changes",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
