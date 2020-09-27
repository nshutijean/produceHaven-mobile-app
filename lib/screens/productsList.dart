import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(ProductsScreen());

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  @override
  ProductsPage({Key key}) : super(key: key);
  _ProductsPageState createState() => _ProductsPageState();
}

class Product {
  final int id;
  final String name;
  final String description;
  final int units;
  final int price;
  final String category;
  final String image;

  Product(this.id, this.name, this.description, this.units, this.price,
      this.category, this.image);
}

class ProductData {
  TextEditingController _name = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _units = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _category = new TextEditingController();
  TextEditingController _image = new TextEditingController();
}

class _ProductsPageState extends State<ProductsPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  ProductData _productData = new ProductData();
  // String _path = "D:\\MyStuff\\EFruitsVegies\\Laravel + VueJs\\workflow\\pht.v1\\public\\";

  // Future<File> _getLocalImage(String imagename) async {
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File f = new File("$dir/$imagename");
  //   return f;
  // }

  int id;
  // int index;

  Future<List<Product>> _getProducts() async {
    var data = await CallApi().getData("products");

    var jsonData = json.decode(data.body);
    // id = jsonData[index]['id'];
    // print(id);

    List<Product> products = [];

    for (var p in jsonData) {
      Product product = Product(p["id"], p["name"], p["description"],
          p["units"], p["price"], p["category"], p["image"]);
      products.add(product);
    }
    print(products.length);
    return products;
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Product'),
            content: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: this._productData._name,
                    keyboardType: TextInputType.text,
                    validator: (String value) {
                      return value.isEmpty ? "Name is required" : null;
                    },
                    onSaved: (String value) {
                      this._productData._name.text = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: this._productData._price,
                    decoration: InputDecoration(
                        labelText: "Product's price",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (String value) {
                      return value.isEmpty ? "Price is required" : null;
                    },
                    onSaved: (String value) {
                      this._productData._price.text = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: this._productData._units,
                    decoration: InputDecoration(
                        labelText: "Product's units",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (String value) {
                      return value.isEmpty ? "Units are required" : null;
                    },
                    onSaved: (String value) {
                      this._productData._units.text = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: this._productData._description,
                    maxLines: 2,
                    decoration: InputDecoration(
                        labelText: "Product's description",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (String value) {
                      return value.isEmpty ? "Description is required" : null;
                    },
                    onSaved: (String value) {
                      this._productData._description.text = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: this._productData._category,
                    decoration: InputDecoration(
                        labelText: "fruit or vegetable",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (String value) {
                      return value.isEmpty ? "Category is required" : null;
                    },
                    onSaved: (String value) {
                      this._productData._category.text = value;
                    },
                  ),
                  // show and update image
                  // TextFormField(
                  //   controller: this._productData._name,
                  //   decoration: InputDecoration(hintText: "Update name"),
                  // ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // _formKey.currentState.save();
                    _updateProduct();
                  }
                  // _updateProduct();

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // padding: const EdgeInsets.all(20.0),
            FutureBuilder(
      future: _getProducts(),
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
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(snapshot.data[index].image),
                  //   maxRadius: 0,
                  // ),
                  // leading: CircleAvatar(
                  //   child: Image.file(
                  //     File(
                  //         "D:/MyStuff/EFruitsVegies/Laravel + VueJs/workflow/pht.v1/public${snapshot.data[index].image}"),
                  //     width: 50.0,
                  //     height: 50.0,
                  //   ),
                  // ),
                  // leading: Card(
                  //   child: Image.file(
                  //     File(
                  //         "D:\\MyStuff\\EFruitsVegies\\Laravel + VueJs\\workflow\\pht.v1\\public\\$snapshot.data[index].image"),
                  // ),
                  // leading: FutureBuilder(
                  //     future: _getLocalImage(
                  //         "D:/MyStuff/EFruitsVegies/Laravel + VueJs/workflow/pht.v1/public${snapshot.data[index].image}"),
                  //     builder:
                  //         (BuildContext context, AsyncSnapshot<File> snapshot) {
                  //       return snapshot.data != null
                  //           ? new Image.file(snapshot.data)
                  //           : new Container();
                  //     }),
                  // leading: Text(),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text("Category: " + snapshot.data[index].category),
                  trailing:
                      Text(snapshot.data[index].price.toString() + " Rwf"),
                  contentPadding: EdgeInsets.only(right: 30.0, left: 30.0),
                  onTap: () {
                    //retrieve an id from snapshot
                    id = snapshot.data[index].id;
                    //price and units have to store an integer
                    this._productData._name.text = snapshot.data[index].name;
                    this._productData._price.text =
                        snapshot.data[index].price.toString();
                    this._productData._units.text =
                        snapshot.data[index].units.toString();
                    this._productData._description.text =
                        snapshot.data[index].description;
                    this._productData._category.text =
                        snapshot.data[index].category;
                    _displayDialog(context);
                  },
                );
              });
        }
      },
    ));
  }

  void _updateProduct() async {
    var prodId;
    setState(() {
      prodId = id;
    });
    var data = {
      'name': this._productData._name.text,
      'description': this._productData._description.text,
      'units': this._productData._units.text,
      'price': this._productData._price.text,
      // 'image': imageRes.toString(),
      'category': this._productData._category.text
    };

    //i need to extract a product's ID, somewhere
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    // var userJson = localStorage.getString('bigStore.user');
    // var user = json.decode(userJson);
    // Product p;
    // int id = p.id;

    String _url = 'http://localhost:8000/api/products/$prodId';
    print(_url);
    await http
        .patch(_url, body: data, headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        })
        .then((response) => print(response.body))
        .catchError((error) => print(error));
  }
}
