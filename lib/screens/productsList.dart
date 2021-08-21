import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';
// import 'package:image/image.dart' as imageUtils;
import 'package:path_provider/path_provider.dart';
import 'package:simple_form/screens/viewQrcode.dart';
// import 'package:simple_form/screens/viewQrcode.dart';

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
  // ProductsPage({Key key, this.qrcodePass});
  // final String qrcodePass;
  _ProductsPageState createState() => _ProductsPageState();
}

class Product {
  final int id;
  final int userId;
  final String name;
  final String description;
  final int units;
  final int price;
  final String category;
  final String qrcodeUrl;
  final String image;

  Product(this.id, this.userId, this.name, this.description, this.units,
      this.price, this.category, this.qrcodeUrl, this.image);
}

class ProductData {
  TextEditingController _name = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _units = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _category = new TextEditingController();
  TextEditingController _qrcodeUrl = new TextEditingController();
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

  //product's id which will be assigned to an id from a list
  int id;
  // public qrcode variable to shared to ViewQrcode class
  var qrcode;

  Future<List<Product>> _getProducts() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');
    String _url = 'http://localhost:8000/api/showWithAuth';
    var data = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // id = jsonData[index]['id'];
    // print(jsonData[12]['qrcodeUrl']);
    var jsonData = json.decode(data.body);
    print(jsonData);

    List<Product> products = [];

    for (var p in jsonData) {
      Product product = Product(
          p["id"],
          p["user_id"],
          p["name"],
          p["description"],
          p["units"],
          p["price"],
          p["category"],
          p["qrcodeUrl"],
          p["image"]);
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
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
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
                  SizedBox(height: 20.0),
                  // Text(this._productData._qrcode_url.text.isEmpty
                  //     ? 'No QRCode provided'
                  //     : this._productData._qrcode_url.text)
                  TextButton(
                    //read qrcodeUrl from DB
                    child: Text(qrcode == 'null'
                        ? 'No QRCode provided'
                        : 'View and share code'),
                    // child: Text('View and share code'),
                    onPressed: () {
                      //if qrcode_url is not empty, open the image and share it
                      if (qrcode != 'null') {
                        //redirects to a page that show a qrcode(png) & passes qrcode to another class
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ViewQrcode(
                            qrcode: qrcode,
                          );
                        }));
                        // Image.network(
                        //     'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg');
                      } else {}
                      //if empty, do nothing
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
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
              // SizedBox(
              //   width: 70.0,
              // ),
              Row(
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // _formKey.currentState.save();
                        _updateProduct();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "List of produces",
            // style: TextStyle(fontSize: 12.0),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
          elevation: 0.0,

          // flexibleSpace: ,
          // leading: Icon(Icons.),
        ),
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
                      subtitle: Text(
                          snapshot.data[index].price.toString() + " Rwf/unit"),
                      trailing:
                          // Text(snapshot.data[index].price.toString() + " Rwf"),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                //create an alertdialog to ask for an action first
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          // side: BorderSide(
                                          //     // color: Colors.grey,
                                          //     style: BorderStyle.solid,
                                          //     width: 1.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      content: Container(
                                        child: Text(
                                            'Do you want to delete this product?'),
                                      ),
                                      title: Text(
                                        'Confirm deletion!',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  int pid =
                                                      snapshot.data[index].id;
                                                  _deleteProduct(pid);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                                //add delete method
                              }),
                      contentPadding: EdgeInsets.only(right: 30.0, left: 30.0),
                      onLongPress: () {
                        // setState(() {
                        qrcode = snapshot.data[index].qrcodeUrl.toString();
                        // });
                        print(qrcode);
                        //retrieve an id from snapshot
                        id = snapshot.data[index].id;
                        //price and units have to store an integer
                        this._productData._name.text =
                            snapshot.data[index].name;
                        this._productData._price.text =
                            snapshot.data[index].price.toString();
                        this._productData._units.text =
                            snapshot.data[index].units.toString();
                        this._productData._description.text =
                            snapshot.data[index].description;
                        this._productData._category.text =
                            snapshot.data[index].category;

                        print(snapshot.data[index].qrcodeUrl.toString());
                        // print(snapshot.data[index].toString());
                        _displayDialog(context);
                      },
                    );
                  });
            }
          },
        ));
  }

  void _deleteProduct(pid) async {
    // print(prodId);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');

    String _url = 'http://localhost:8000/api/products/$pid';
    print(_url);
    var res = await http.delete(_url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    //turn the response to json data
    var body = json.decode(res.body);
    print(body);

    //status checking, API response message
    if (res.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
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

    //i need to extract a product's ID, somewhere ✅
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');

    String _url = 'http://localhost:8000/api/products/$prodId';
    print(_url);
    var res = await http.patch(_url, body: data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    //turn the response to json data
    var body = json.decode(res.body);

    //status checking, API response message
    if (res.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }
}
