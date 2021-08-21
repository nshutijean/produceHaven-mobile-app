import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MaterialApp(
    home: ViewQrcode(),
  ));
}

class ViewQrcode extends StatelessWidget {
  //receive the public qrcode variable into a constructor
  String qrcode;
  ViewQrcode({this.qrcode});

  // String qrCodeUrl =
  //     "https://codespeedy.com/wp-content/uploads/2020/01/Qrcode.png";

  @override
  Widget build(BuildContext context) {
    print('Qrcode:' + qrcode);
    return Scaffold(
      appBar: AppBar(
        title: Text('QR code'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.open_in_browser, color: Colors.white),
              onPressed: () {
                //open the product in the PWA app/browser
              }),
          IconButton(
              icon: Icon(Icons.file_download, color: Colors.white),
              onPressed: () {
                //download the image to local phone storage
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 30.0,
            ),
            child: Text(
              'Share QR code',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            // color: Colors.white,
            // height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(5.0),
              shadowColor: Colors.transparent,
              color: Colors.white,
              // elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                    child: CachedNetworkImage(
                  imageUrl: qrcode,
                )),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          //You need to make a reusable function(it looks ugly)
          Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: RichText(
                        text: TextSpan(
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Press '),
                    WidgetSpan(
                        child: Icon(
                      Icons.share,
                      size: 14,
                    )),
                    TextSpan(text: ' to share your QR code'),
                  ],
                ))),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: RichText(
                        text: TextSpan(
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Press '),
                    WidgetSpan(
                        child: Icon(
                      Icons.open_in_browser,
                      size: 14,
                    )),
                    TextSpan(text: ' to view the product in browser'),
                  ],
                ))),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: RichText(
                        text: TextSpan(
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Press '),
                    WidgetSpan(
                        child: Icon(
                      Icons.file_download,
                      size: 14,
                    )),
                    TextSpan(text: ' to download the QR code'),
                  ],
                ))),
              ],
            ),
          ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //onTap() share the Qr code image to different platforms
          _shareText();
        },
        child: Icon(
          Icons.share,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Future<void> _shareImageFromUrl() async {
  //   try {
  //     var request = await HttpClient().getUrl(Uri.parse(qrcode));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     await Share.file('QR code', 'product_qrcode.png', bytes, 'image/png');
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

  Future<void> _shareText() {
    try {
      Share.text(
          'text test', 'This text should be seen in message box', 'text/plain');
    } catch (e) {}
  }
}
