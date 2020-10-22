import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_form/api/api.dart';

void main() {
  runApp(MaterialApp(
    home: UploadProduct(),
  ));
}

class UploadProduct extends StatefulWidget {
  UploadProduct({Key key}) : super(key: key);

  @override
  _UploadProductState createState() => _UploadProductState();
}

class ProductData {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _units = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _image = TextEditingController();
}

class _UploadProductState extends State<UploadProduct> {
  String type = "";
  var _categories = ['Fruit', 'Vegetable'];
  var _currenItemsSelected = 'Fruit';

  File imageFile;
  final picker = ImagePicker();
  var response;

  static bool isUploading = false;

  ProductData _productData = new ProductData();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(pickedFile.path);
      // imageFile = pickedFile as File;
    });

    Navigator.of(context).pop();
  }

  Future getImage(context) async {
    var image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500.0,
        maxWidth: 500.0);
    imageFile = File(image.path);
    _uploadFile(imageFile);
    Navigator.of(context).pop();
  }

  _uploadFile(File file) async {
    String name = file.path.split('/').last;
    var data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: name,
      ),
    });

    Dio dio = new Dio();
    response =
        await dio.post("http://localhost:8000/api/upload-file", data: data);
    // .then((response) => print(response))
    // .catchError((error) => print(error));
    print(response.data["0"]);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload using:"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    // uploadFile(context); // startUpload();
                    getImage(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //footer
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
                isUploading ? "Uploading" : "Upload",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  print("P_name: ${_productData._name.text}");
                  print("P_price: ${_productData._price.text}");
                  print("P_units: ${_productData._units.text}");
                  print("P_description: ${_productData._description.text}");
                  print("P_category: ${_currenItemsSelected.toString()}");
                }
                isUploading ? null : _saveProduct();
              },
            ),
          )
        ],
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
            child: new Container(
                padding: EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 0),
                child: Form(
                    key: this._formKey,
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 65.0, 10.0),
                        child: Text(
                          "Upload Product",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.normal),
                          // textAlign: TextAlign.left,
                        ),
                      ),
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
                            hintText: "Set name",
                            labelText: "Product's name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._productData._price,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Price is required";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this._productData._price.text = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Set price",
                            labelText: "Product's price",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._productData._units,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Units are required";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this._productData._units.text = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Set units",
                            labelText: "Product's units",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      // SizedBox(
                      //   height: 5.0,
                      // ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: this._productData._description,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this._productData._description.text = value;
                        },
                        maxLines: 2,
                        decoration: InputDecoration(
                            hintText: "Set description",
                            labelText: "Product's description",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                        child: Align(
                          child: Text(
                            "Select produce category:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                                fontSize: 16.0),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      DropdownButton<String>(
                        items: _categories.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          _dropDrownItemSelected(newValueSelected);
                        },
                        value: _currenItemsSelected,
                        isExpanded: true,
                      ),
                      // SizedBox(
                      //   height: 5.0,
                      // ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            child: Align(
                              child: Text(
                                "Take picture:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontSize: 16.0),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          SizedBox(width: 30.0),
                          MaterialButton(
                            elevation: 4.0,
                            color: Colors.green,
                            textColor: Colors.white,
                            splashColor: Colors.greenAccent,
                            child: Icon(
                              Icons.camera_alt,
                              size: 24,
                            ),
                            padding: EdgeInsets.all(14),
                            shape: CircleBorder(),
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                          ),
                        ],
                      ),

                      //footer
                      footerSection
                    ])))));
  }

  void _dropDrownItemSelected(String newValueSelected) {
    setState(() {
      this._currenItemsSelected = newValueSelected;
    });
  }

  void _saveProduct() async {
    var imageRes;
    setState(() {
      isUploading = true;
      imageRes = response.data["0"];
    });

    var data = {
      'name': this._productData._name.text,
      'description': this._productData._description.text,
      'units': this._productData._units.text,
      'price': this._productData._price.text,
      'image': imageRes.toString(),
      'category': this._currenItemsSelected.toString()
    };
    // print(data);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('bigStore.jwt');

    String _url = 'http://localhost:8000/api/products';
    var res = await http.post(_url, body: data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      _formKey.currentState.save();
      // print(res.body.toString());

      //API response message on an alertdialog()
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(body['message']),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));

      //
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // shape: RoundedRectangleBorder(
            //     side: BorderSide(
            //         color: Colors.green, style: BorderStyle.solid, width: 1.5),
            //     borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              child: RaisedButton(
                  child: Text(
                    'Open QRCode',
                    style: TextStyle(color: Colors.green),
                  ),
                  color: Colors.white,
                  onPressed: null),
              // child: InkWell(
              //   child: Text('View and share QRCode'),
              // ),
            ),
            title: Text(
              'QRcode created!',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //if product created reset the form(doesnt work😒)
                    _formKey.currentState.reset();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.green),
                  ))
            ],
          );
        },
      );
    } else {
      print("Failed to stored product");
      print(body['message']);

      //API response message on an alertdialog()
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              // child: Text('Error: ' + body['message']),
              child: Text('Check inputs and retry again!'),
            ),
            title: Text(
              'Error: Retry again',
              style: TextStyle(color: Colors.red, fontSize: 18.0),
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

    setState(() {
      isUploading = false;
    });
  }
}
