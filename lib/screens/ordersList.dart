import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_form/api/api.dart';

void main() => runApp(OrdersScreen());

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrdersPage(),
    );
  }
}

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class Order {
  final int productId;
  final int quantity;
  final String address;
  final bool isDelivered;

  Order(this.productId, this.quantity, this.address, this.isDelivered);
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Order>> _getOrders() async {
    var data = await CallApi().getData("orders");

    var jsonData = json.decode(data.body);

    List<Order> orders = [];

    for (var o in jsonData) {
      Order order = Order(
          o["product_id"], o["quantity"], o["address"], o["is_delivered"]);
      orders.add(order);
    }
    print(orders.length);
    return orders;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          headerSection,
          FutureBuilder(
            future: _getOrders(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(snapshot.data[index].productId),
                        title: Text(snapshot.data[index].quantity),
                        subtitle: Text(snapshot.data[index].address),
                        isThreeLine: snapshot.data[index].isDelivered,
                      );
                    });
              }
            },
          )
        ],
      ),
    );
  }
}
